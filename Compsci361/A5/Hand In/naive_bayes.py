import numpy as np

#calculate prior probabilities 
def priors(labels_train,features_train,word_occurances):
 
    instance_class_groups = list()
    occurance_class_groups = list()
    class_prior = list()
    for label in np.unique(labels_train):
        class_subset= features_train[label==labels_train]
        #counts by class
        instance_class_groups.append(features_train[label==labels_train]) 
        # occurances by class
        occurance_class_groups.append(word_occurances[label==labels_train])
        
        #calculate prior for the class
        prior = class_subset.shape[0]/features_train.shape[0]
        class_prior.append(prior)

    class_prior = np.array(class_prior)
    
    return class_prior,occurance_class_groups,instance_class_groups

#calculate prior probabilities 
def likelihood(instance_class_groups,occurance_class_groups, weights):
 
    count_per_class = list()
    alpha = 0.5 #laplace smoothing term

    weight_conditional_prob = list()
    for class_features, occurance_features in zip(instance_class_groups,occurance_class_groups):
        #weighted count(w,c)
        class_weights = np.sum(weights * occurance_features, axis=0)

        #|V|
        number_of_words = class_weights.shape[0]

        #weighted count(c)
        weight_sum = np.sum(class_weights)

        #weighted likelihood p(w|c)
        weight_conditional_prob.append(np.log(class_weights + alpha) - np.log(weight_sum + number_of_words))

    weight_conditional_prob = np.array(weight_conditional_prob) 
    
    return weight_conditional_prob

#predict using the test instances
def predict(features_test,weight_conditional_prob,class_prior):
    
    #go through each test case and predict
    pred = list()
    for counts in features_test:
        #choosing a class
        class_prob = np.sum(weight_conditional_prob*counts, axis=1) + np.log(class_prior)
        #argmax then picks the class
        pred.append(np.argmax(class_prob))
    
    return pred