Training the random Forrest with these settings took 744 seconds on a modern server with 32 GB RAM and can be summarized like this:

```
Call:
 randomForest(formula = my.form, data = trainframe, ntree = my.ntree, mtry = my.mtry, get.importance = get.importance.Q) 
               Type of random forest: classification
                     Number of trees: 200
No. of variables tried at each split: 10

        OOB estimate of  error rate: 9.16%
Confusion matrix:
                        FALSE-FALSE-FALSE-FALSE FALSE-FALSE-FALSE-TRUE FALSE-FALSE-TRUE-FALSE FALSE-FALSE-TRUE-TRUE
FALSE-FALSE-FALSE-FALSE                  180960                   1707                   1943                   363
FALSE-FALSE-FALSE-TRUE                     5353                  35693                    535                   474
FALSE-FALSE-TRUE-FALSE                     3244                    426                  43996                    86
FALSE-FALSE-TRUE-TRUE                       726                    221                    185                 23159
FALSE-TRUE-FALSE-FALSE                     6139                    185                    188                    23
FALSE-TRUE-FALSE-TRUE                       280                     10                     94                    35
TRUE-FALSE-FALSE-FALSE                      689                     72                     67                   661
TRUE-TRUE-FALSE-FALSE                      5318                    546                    114                    23
                        FALSE-TRUE-FALSE-FALSE FALSE-TRUE-FALSE-TRUE TRUE-FALSE-FALSE-FALSE TRUE-TRUE-FALSE-FALSE class.error
FALSE-FALSE-FALSE-FALSE                   4217                    89                    468                  3416  0.06317462
FALSE-FALSE-FALSE-TRUE                     191                    11                     65                   365  0.16384379
FALSE-FALSE-TRUE-FALSE                     126                    29                    114                    36  0.08450382
FALSE-FALSE-TRUE-TRUE                       18                    62                    703                    45  0.07802858
FALSE-TRUE-FALSE-FALSE                   64374                    79                      0                  1811  0.11572961
FALSE-TRUE-FALSE-TRUE                       74                  5825                      0                   103  0.09282043
TRUE-FALSE-FALSE-FALSE                       6                     0                  21464                    21  0.06597041
TRUE-TRUE-FALSE-FALSE                     2149                   142                      4                 61475  0.11890327
```

The accuracy, assessed with the 10% validation set, is similar.

```
Confusion Matrix and Statistics

                         Reference
Prediction                FALSE-FALSE-FALSE-FALSE FALSE-FALSE-FALSE-TRUE FALSE-FALSE-TRUE-FALSE FALSE-FALSE-TRUE-TRUE
  FALSE-FALSE-FALSE-FALSE                   20130                    556                    361                    66
  FALSE-FALSE-FALSE-TRUE                      225                   4034                     48                    21
  FALSE-FALSE-TRUE-FALSE                      200                     54                   4916                    25
  FALSE-FALSE-TRUE-TRUE                        31                     53                     10                  2437
  FALSE-TRUE-FALSE-FALSE                      419                     16                     10                     2
  FALSE-TRUE-FALSE-TRUE                        10                      1                      3                     3
  TRUE-FALSE-FALSE-FALSE                       57                      6                     16                    78
  TRUE-TRUE-FALSE-FALSE                       402                     48                      1                     4
                         Reference
Prediction                FALSE-TRUE-FALSE-FALSE FALSE-TRUE-FALSE-TRUE TRUE-FALSE-FALSE-FALSE TRUE-TRUE-FALSE-FALSE
  FALSE-FALSE-FALSE-FALSE                    643                    35                     85                   587
  FALSE-FALSE-FALSE-TRUE                      18                     1                      7                    55
  FALSE-FALSE-TRUE-FALSE                      19                    11                      8                     8
  FALSE-FALSE-TRUE-TRUE                        1                     2                     66                     1
  FALSE-TRUE-FALSE-FALSE                    7267                    10                      3                   239
  FALSE-TRUE-FALSE-TRUE                       10                   656                      1                    15
  TRUE-FALSE-FALSE-FALSE                       0                     0                   2417                     1
  TRUE-TRUE-FALSE-FALSE                      203                     7                      4                  6822

Overall Statistics
                                          
               Accuracy : 0.9108          
                 95% CI : (0.9084, 0.9132)
    No Information Rate : 0.4018          
    P-Value [Acc > NIR] : < 2.2e-16       
                                          
                  Kappa : 0.8836          
 Mcnemar's Test P-Value : < 2.2e-16       

Statistics by Class:

                     Class: FALSE-FALSE-FALSE-FALSE Class: FALSE-FALSE-FALSE-TRUE Class: FALSE-FALSE-TRUE-FALSE
Sensitivity                                  0.9374                       0.84606                       0.91631
Specificity                                  0.9270                       0.99230                       0.99324
Pos Pred Value                               0.8961                       0.91495                       0.93799
Neg Pred Value                               0.9566                       0.98503                       0.99069
Prevalence                                   0.4018                       0.08921                       0.10038
Detection Rate                               0.3766                       0.07548                       0.09198
Detection Prevalence                         0.4203                       0.08250                       0.09806
Balanced Accuracy                            0.9322                       0.91918                       0.95477
                     Class: FALSE-FALSE-TRUE-TRUE Class: FALSE-TRUE-FALSE-FALSE Class: FALSE-TRUE-FALSE-TRUE
Sensitivity                               0.92451                        0.8905                      0.90859
Specificity                               0.99677                        0.9846                      0.99918
Pos Pred Value                            0.93695                        0.9123                      0.93848
Neg Pred Value                            0.99609                        0.9803                      0.99875
Prevalence                                0.04932                        0.1527                      0.01351
Detection Rate                            0.04560                        0.1360                      0.01227
Detection Prevalence                      0.04867                        0.1491                      0.01308
Balanced Accuracy                         0.96064                        0.9375                      0.95389
                     Class: TRUE-FALSE-FALSE-FALSE Class: TRUE-TRUE-FALSE-FALSE
Sensitivity                                0.93284                       0.8828
Specificity                                0.99689                       0.9854
Pos Pred Value                             0.93864                       0.9107
Neg Pred Value                             0.99658                       0.9803
Prevalence                                 0.04848                       0.1446
Detection Rate                             0.04522                       0.1276
Detection Prevalence                       0.04818                       0.1402
Balanced Accuracy                          0.96487                       0.9341
```	
