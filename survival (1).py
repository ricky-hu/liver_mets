# Survival analysis functions for the liver data.

import numpy as np

def extract_time_event_and_features(clinical_data):
    time = clinical_data['FFLP_in_months']
    event = clinical_data['FFLP']

    fdata = clinical_data.drop(columns=['FFLP_in_months', 'FFLP', 'filename'])

    return time, event, fdata

from statsmodels.stats.outliers_influence import variance_inflation_factor    

def calculate_vif_(X, thresh=20.0):
    variables = list(range(X.shape[1]))
    dropped = True
    while dropped:
        dropped = False
        vif = [variance_inflation_factor(X.iloc[:, variables].values, ix)
               for ix in range(X.iloc[:, variables].shape[1])]

        maxloc = vif.index(max(vif))
        if max(vif) > thresh:
            #print('dropping \'' + X.iloc[:, variables].columns[maxloc] +
            #      '\' at index: ' + str(maxloc))
            del variables[maxloc]
            dropped = True

    #print('Remaining variables:')
    #print(X.columns[variables])
    return X.iloc[:, variables]

from scipy.stats import pearsonr
def remove_nan_correlations(fdata2, time):
    todel = []
    for cols in fdata2.columns:
        corrl, dummy = pearsonr(fdata2[cols], time)
        if np.isnan(corrl):
            todel.append(cols)
        #print(cols, ': \t', corrl)
    return fdata2.drop(columns=todel)

def prepare_data(clinical_data, display_cmat=True, VIF=10, skip_variable_reduction=False):
    #VIF of 10 means that all the features with R^2 above 0.9 will removed
    
    time, event, fdata = extract_time_event_and_features(clinical_data)
    if not skip_variable_reduction:
        fdata2 = calculate_vif_(fdata, VIF)
    else:
        fdata2 = fdata
    fdata2 = remove_nan_correlations(fdata2, time)
    if display_cmat:
        from pysurvival.utils.display import correlation_matrix
        correlation_matrix(fdata2, figure_size=(30,15), text_fontsize=10)
    return fdata2, time, event

from sklearn.model_selection import StratifiedKFold
from pysurvival.models.survival_forest import RandomSurvivalForestModel
from pysurvival.utils.metrics import concordance_index, integrated_brier_score as ibs_no_figure
from pysurvival.utils.display import compare_to_actual
from pysurvival.utils.display import integrated_brier_score
def cv_train_and_report_model(X, T, E, show=True, num_tree=10, max_depth=1, min_node=2, kf=None, prep_model=None):
    if prep_model is None:
        def _prep_model(X, T, E):
            xst = RandomSurvivalForestModel(num_trees=num_tree) 
            xst.fit(X, T, E, max_features = 'sqrt', max_depth = max_depth,
                min_node_size = min_node, num_threads = -1, 
                sample_size_pct = 0.63, importance_mode = 'normalized_permutation',
                seed = None, save_memory=False )
            return xst
        prep_model = _prep_model
    i=1
    if kf is None:
        kf=StratifiedKFold(n_splits=10, shuffle=True)
    cis = []
    ibss = []
    for train_index, test_index in kf.split(X,E):
        
        X_train, X_test = X.iloc[train_index], X.iloc[test_index]
        T_train, T_test = T.iloc[train_index], T.iloc[test_index]
        E_train, E_test = E.iloc[train_index], E.iloc[test_index]
        #xst = RandomSurvivalForestModel(num_trees=num_tree) 
        #xst.fit(X_train, T_train, E_train, max_features = 'sqrt', max_depth = max_depth,
        #    min_node_size = min_node, num_threads = -1, 
        #    sample_size_pct = 0.63, importance_mode = 'normalized_permutation',
        #    seed = None, save_memory=False )
        xst = prep_model(X_train, T_train, E_train)
        c_index = concordance_index(xst, X_test, T_test, E_test)
        
        if show:
            print('\n {} of kfold {}'.format(i,kf.n_splits))
            print('C-index: {:.2f}'.format(c_index))
            results = compare_to_actual(xst, X_test, T_test, E_test, is_at_risk = True,  figure_size=(16, 6), 
                                        metrics = ['rmse', 'mean', 'median'])
            ibs = integrated_brier_score(xst, X_test, T_test, E_test, t_max=100, figure_size=(15,5))
            print('IBS: {:.2f}'.format(ibs))
        else:
            ibs = ibs_no_figure(xst, X_test, T_test, E_test, t_max=100)
        cis.append(c_index)
        ibss.append(ibs)
        i=i+1
    return cis, ibss

def grid_search_for_model(X, T, E, num_tree, max_depth, min_node, n_splits=5):
    maxcc = 0
    answer = None
    for a in num_tree:
        print("Num tree =", a)
        for b in max_depth:
            for c in min_node:
                kf = StratifiedKFold(n_splits=n_splits, random_state=42, shuffle=True)
                ccs, ibss = cv_train_and_report_model(X, T, E, show=False, num_tree=a, max_depth=b, min_node=c, kf=kf)
                mn = np.mean(ccs)
                #print(a,b, c, mn)
                if mn > maxcc:
                    answer = a,b,c
                    maxcc = mn
    return answer
   

def optimize_grid_and_report_results(fdata2, time, event, k_folds=5, show_final_cv=True, full_output=False):
    num_tree=(10, 12, 15, 20, 50, 100)
    max_depth=(1, 2, 3, 4, 5, 6, 10, 12, 15)
    min_node=(1, 2, 3, 4, 5, 10, 12, 15, 20)
    b_num_tree, b_max_depth, b_min_node = grid_search_for_model(fdata2, time, event, num_tree, max_depth, min_node)                
    kf=StratifiedKFold(n_splits=k_folds, random_state=42, shuffle=True)
    ccs, ibss = cv_train_and_report_model(fdata2, time, event, num_tree=b_num_tree, max_depth=b_max_depth, min_node=b_min_node, kf=kf, show=show_final_cv)
    ccs, ibss = np.asarray(ccs), np.asarray(ibss)
    if show_final_cv:
        print(f"ci = {ccs.mean()} +- {ccs.std()},\tibs = {ibss.mean()} +- {ibss.std()}")
    if not full_output:
        return ccs, ibss
    else:
        return dict(ci=ccs, ibs=ibss, num_tree=b_num_tree, max_depth=b_max_depth, min_node=b_min_node)
    
def grid_search_and_retrain(X, T, E, num_tree, max_depth, min_node):
    b_num_tree, b_max_depth, b_min_node = grid_search_for_model(X, T, E, num_tree, max_depth, min_node)
    xst = RandomSurvivalForestModel(num_trees=b_num_tree) 
    xst.fit(X, T, E, max_features = 'sqrt', max_depth = b_max_depth,
            min_node_size = b_min_node, num_threads = -1, 
            sample_size_pct = 0.63, importance_mode = 'normalized_permutation',
            seed = 954, save_memory=False )
    return xst, b_num_tree, b_max_depth, b_min_node

def grid_search_inside_cv(fdata2, time, event, k_folds=5, show_final_cv=True, full_output=False):
    num_tree=(10, 15, 20, 50, 100, 200)
    max_depth=(1, 2, 3, 5, 10, 12, 15)
    min_node=(1, 2, 3, 5, 10, 12)
    
    num_trees = []
    max_depths = []
    min_nodes = []
    
    def grid_prep_model(X, T, E):
        xst, b_num_tree, b_max_depth, b_min_node = grid_search_and_retrain(X, T, E, num_tree, max_depth, min_node)
        
        num_trees.append(b_num_tree)
        max_depths.append(b_max_depth)
        min_nodes.append(b_min_node)
        
        return xst
    
    #grid_prep_model = lambda X, T, E: grid_search_and_retrain(X, T, E, num_tree, max_depth, min_node)
    kf=StratifiedKFold(n_splits=k_folds, random_state=1, shuffle=True)
    ccs, ibss = cv_train_and_report_model(fdata2, time, event, kf=kf, show=show_final_cv, prep_model=grid_prep_model)
    ccs, ibss = np.asarray(ccs), np.asarray(ibss)
    if show_final_cv:
        print(f"ci = {ccs.mean()} +- {ccs.std()},\tibs = {ibss.mean()} +- {ibss.std()}")
    if not full_output:
        return ccs, ibss
    else:
        return dict(ci=ccs, ibs=ibss, num_tree=num_trees, max_depth=max_depths, min_node=min_nodes)
    
    