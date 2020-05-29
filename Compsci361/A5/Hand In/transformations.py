import numpy as np
import copy

#convert features to counts
def features_count_transform(all_words, features):

    unique_words = np.unique(all_words)
    keys = list(np.array(unique_words))
    values = list(np.arange(0,len(unique_words)))
    rows = len(features)
    cols = len(unique_words)

    word_mapping = dict(zip(keys,values))

    #preallocate numpy matrix
    word_counts = np.zeros((rows, cols))

    for index in range(0, features.shape[0]):

        abstract = features[index]
        word_count_per_abstract = list()
        count = 0
        words, counts = np.unique(abstract, return_counts=True) #returns counts of words in abstracts

        #assign words and counts to the preallocated matrix
        for word_index in range(0, len(words)):
            word = words[word_index]
            count = counts[word_index]
            try:
                col_index = word_mapping[word]
                word_counts[index, col_index] = count
            except KeyError:
                #means word is not in both test and training set so skip
                pass
        
            
    return word_counts

#convert features to occurances
def feature_occurance_transform(features_train):
    
    word_occurances = copy.deepcopy(features_train)
    word_occurances[features_train > 0] = 1

    weights = np.log(np.divide(word_occurances.shape[0],np.sum(word_occurances,axis=0)+1))
    
    return weights,word_occurances