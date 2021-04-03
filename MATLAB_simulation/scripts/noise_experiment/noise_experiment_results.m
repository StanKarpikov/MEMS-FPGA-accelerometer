%>
%> @file noise_experiment_results.m
%>
%> @author Stanislav Karpikov
%>
%> @brief Shows the results of the experimental noise measurement
%>

clear all;

% Input signal - experimental results
Signal = [ -0.00009
-0.000025
0.000007
0.000066
-0.000098
0.000166
-0.000267
0.000033
0.000039
-0.000125
0.000093
-0.000215
0.000152
-0.000249
0.000015
0.000001
-0.000121
0.000082
-0.000136
0.000116
0.000033
0.000074
-0.000091
-0.000136
0.000097
-0.000267
0.000093
-0.000026
-0.000069
0.000146
-0.000149
0.000065
-0.000009
-0.000015
0.000081
0.000034
0.000081
-0.00022
0.000133
-0.00005
-0.000077
0.000089
-0.000174
0.00004
0.000052
-0.000087
-0.000109
-0.000032
-0.000092
-0.000115
0.000165
-0.000046
-0.000115
0.000111
-0.000143
-0.000073
0.000004
-0.000115
-0.000104
0.000018
0.000002
-0.000158
0.000008
-0.000072
-0.000191
-0.000074
-0.000119
-0.000088
-0.000104
0.000029
-0.000098
-0.000096
-0.000013
-0.000151
-0.000067
0.000005
-0.000002
-0.000207
-0.000131
-0.000154
-0.000312
0.000018
-0.000105
-0.000139
-0.00002
-0.000099
-0.000223
-0.000111
-0.00023
-0.000179
-0.000131
-0.000166
-0.000122
-0.000178
-0.000152
-0.000319
-0.000014
-0.000105
-0.000235
-0.000058
-0.000211
-0.000209
-0.000292
-0.000128
-0.000202
-0.000223
-0.000113
-0.000321
-0.000167
-0.000285
-0.000246
-0.000092
-0.00027
-0.000202
-0.000332
-0.000152
-0.000337
-0.000188
-0.000104
-0.000298
-0.000154
-0.000284
-0.000213
-0.000257
-0.000351
-0.000261
-0.000339
-0.000175
-0.000387
-0.000235
-0.000296
-0.000213
-0.000142
-0.000483
-0.000191
-0.000324
-0.000438
-0.000193
-0.000333
-0.000245
-0.000275
-0.000333
-0.000321
-0.000311
-0.000233
-0.000409
-0.000296
-0.000264
-0.000394
-0.000332
-0.000326
-0.000398
-0.000329
-0.000297
-0.000356
-0.000466
-0.000199
-0.000357
-0.00036
-0.000206
-0.000448
-0.000263
-0.000259
-0.000296
-0.000277
-0.000212
-0.000224
-0.000514
-0.000153
-0.000443
-0.000465
-0.000146
-0.000529
-0.000272
-0.000231
-0.000483
-0.000303
-0.000285
-0.000388
-0.000308
-0.000288
-0.000388
-0.000432
-0.000227
-0.000559
-0.000266
-0.000368
-0.000494
-0.000234
-0.000464
-0.000396
-0.00037
-0.000334
-0.000362
-0.000357
-0.000335
-0.000472
-0.000384
-0.000418
-0.000515
-0.000193
-0.000559
-0.000384
-0.000303
-0.000396
-0.000343
-0.000566
-0.000323
-0.000539
-0.000345
-0.000389
-0.000531
-0.000354
-0.000475
-0.000381
-0.000351
-0.000543
-0.000329
-0.000399
-0.000408
-0.000376
-0.000432
-0.000349
-0.000553
-0.000316
-0.000482
-0.000514
-0.000357
-0.000549
-0.000272
-0.000549
-0.000418
-0.000503
-0.000628
-0.000413
-0.00058
-0.000442
-0.000503
-0.00052
-0.0004
-0.000556
-0.000421
-0.000514
-0.000522
-0.000559
-0.000485
-0.00044
-0.000574
-0.000346
-0.000508
-0.000524
-0.000455
-0.000586
-0.000492
-0.000486
-0.000473
-0.000495
-0.000508
-0.000244
-0.0006
-0.000452
-0.000418
-0.000701
-0.000387
-0.000492
-0.000557
-0.00063
-0.000398
-0.000472
-0.000639
-0.000381
-0.000632
-0.000503
-0.000339
-0.000534
-0.000438
-0.000539
-0.000496
-0.000534
-0.000542
-0.000561
-0.000552
-0.000442
-0.000623
-0.000474
-0.00041
-0.000542
-0.000392
-0.000504
-0.000544
-0.000545
-0.000489
-0.000504
-0.00057
-0.000438
-0.000533
-0.000477
-0.000334
-0.000464
-0.000486
-0.000424
-0.000478
-0.000455
-0.000394
-0.000525
-0.000543
-0.000423
-0.000563
-0.00047
-0.000315
-0.000569
-0.000441
-0.000452
-0.000505
-0.000544
-0.0005
-0.000505
-0.000453
-0.000529
-0.000411
-0.000431
-0.000471
-0.000567
-0.00041
-0.000454
-0.000613
-0.000463
-0.000569
-0.000455
-0.000371
-0.00047
-0.000452
-0.000474
-0.000594
-0.000452
-0.000471
-0.00047
-0.000552
-0.000511
-0.000559
-0.000394
-0.000458
-0.000521
-0.000387
-0.000571
-0.000461
-0.00037
-0.000548
-0.000496
-0.000436
-0.000473
-0.000501
-0.00055
-0.000538
-0.00058
-0.00044
-0.000457
-0.000468
-0.000368
-0.000499
-0.000537
-0.000557
-0.000518
-0.000509
-0.000517
-0.000504

-0.00036
-0.000629
-0.00045
-0.000412
-0.000672
-0.000392
-0.000482
-0.000676
-0.000416
-0.000506
-0.000594
-0.000497
-0.000403
-0.000532
-0.000486
-0.000363
-0.000641
-0.000412
-0.000585
-0.000558
-0.000457
-0.000473
-0.000418
-0.000485
-0.000356
-0.000586

-0.000407
-0.000569
-0.000491
-0.0006
-0.000578
-0.000402
-0.000553
-0.000452
-0.000462
-0.000496
-0.000538
-0.00061
-0.00049
-0.000641
-0.000357
-0.000483
-0.000538
-0.000414
-0.000518
-0.000514
-0.000519
-0.000465
-0.000548
-0.000481
-0.000416
-0.000543
-0.00048
-0.000558
-0.000497
-0.000483
-0.000563
-0.000341
-0.000554
-0.000508
-0.000371
-0.000569
-0.00043
-0.000639
-0.00054
-0.000543
-0.000607
-0.00029
-0.00063
-0.000424
-0.00044
-0.000486
-0.000528
-0.000543
-0.000435
-0.000693
-0.000302
-0.000425
-0.00056
-0.000257
-0.000573
-0.000518
-0.000392
-0.000618
-0.000461
-0.000578
-0.000417
-0.000527
-0.00056
-0.000497
-0.000566
-0.000495
-0.000851
-0.000415
-0.00062
-0.000603
-0.000393
-0.00063
-0.000315
-0.000415
-0.000561
-0.000576
-0.000495
-0.000638
-0.000641
-0.000485
-0.000616

-0.000502
-0.000799
-0.000438
-0.000549
-0.000761
-0.000433
-0.000775
-0.000545
-0.000425
-0.000516
-0.000526
-0.000607
-0.000559
-0.000592
-0.000309
-0.000654
-0.000562
-0.000404
-0.000637
-0.000463
-0.000613
-0.000623
-0.000511
-0.000527
-0.000547
-0.000545
-0.000478
-0.000603
-0.000506
-0.00055
-0.000602
-0.000383
-0.000534
-0.000712
-0.000439
-0.000527
-0.000563
-0.000421
-0.000558
-0.000523
-0.000489
-0.000483
-0.000793
-0.000327
-0.000581
-0.000718
-0.000378
-0.000724
-0.000458
-0.000471
-0.00056
-0.000575
-0.000546
-0.000442
-0.000545
-0.00038
-0.000554
-0.00053
-0.000527
-0.000649
-0.000584
-0.000536
-0.000512
-0.000436
-0.000509
-0.000496
-0.000593
-0.000518
-0.000452
-0.000618
-0.000462
-0.000569
-0.000407
-0.000514
-0.000502
-0.00048
-0.000657
-0.000501
-0.0006
-0.000394
-0.000474
-0.00045
-0.000558
-0.000484
-0.00044
-0.000613
-0.00049
-0.000516
-0.00059
-0.000398
-0.000526
-0.000455
-0.000479
-0.000479
-0.000462
-0.00054
-0.000522
-0.000542
-0.000627
-0.000479
-0.000465
-0.000448
-0.00039
-0.000361
-0.000567
-0.000419
-0.000496

-0.000461
-0.000506
-0.00058
-0.000449
-0.000448
-0.000392
-0.000541
-0.000463
-0.000542
-0.000577
-0.000503
-0.00057
-0.000435
-0.000382
-0.00053
-0.000488
-0.000491
-0.000536
-0.000477
-0.000468
-0.000464
-0.000538
-0.000479
-0.000456
-0.000512
-0.000397
-0.000544
-0.000371
-0.000608
-0.000468
-0.000354
-0.000514
-0.0004
-0.000576
-0.000547
-0.000568
-0.000495
-0.000507
-0.000522
-0.000482
-0.000493
-0.000428
-0.000422
-0.000506
-0.000512
-0.00053
-0.000494
-0.000494
-0.000495
-0.000304
-0.000393
-0.000426
-0.000459
-0.000368
-0.000427
-0.000515
-0.00032
-0.000577
-0.000402
-0.000413
-0.000564
-0.000277
-0.000477
-0.000452
-0.000419
-0.000391
-0.000454
-0.000483
-0.000189
-0.000475
-0.000388
-0.000389
-0.000465
-0.000242
-0.000539
-0.000384
-0.000526
-0.000375
-0.000386
-0.000457
-0.000246
-0.00047
-0.0003
-0.000364
-0.000432
-0.000261
-0.000348
-0.000228
-0.000362
-0.000378
-0.000299
-0.000363
-0.000234
-0.000408
-0.000281
-0.000337
-0.000405
-0.00018
-0.000416
-0.000314
-0.000358
-0.00043
-0.000166
-0.000459
-0.000297
-0.000344
-0.000375
-0.000277
-0.0004
-0.000224
-0.000543
-0.000284
-0.000384
-0.00041
-0.0002
-0.000463
-0.000353
-0.000335
-0.000368
-0.000359
-0.000335
-0.000336
-0.000338
-0.000244
-0.000257
-0.000425
-0.000274
-0.000275
-0.00047
-0.000248
-0.000423
-0.00028
-0.000184
-0.000272
-0.000235
-0.000249
-0.000211
-0.000334
-0.000183
-0.000353
-0.000392
-0.000089
-0.000507
-0.000198
-0.000305
-0.000472
-0.000208
-0.000477
-0.000243
-0.000296
-0.000335
-0.000305
-0.000434
-0.000313
-0.000448
-0.000292
-0.000291
-0.000274
-0.000057
-0.000381
-0.000136
-0.000307
-0.000445
-0.000274
-0.000337
-0.000215
-0.000423
-0.000144
-0.00039
-0.000219
-0.000004
-0.000391
-0.000147
-0.00014
-0.000454
-0.000236
-0.000228
-0.000305
-0.000323
-0.000227
-0.000291
-0.000341
-0.000238
-0.000266
-0.000217
-0.000282
-0.00037
-0.000034
-0.000263
-0.000186
-0.000229
-0.000348
-0.000197
-0.000365
-0.000247
-0.000248
-0.000273
-0.000205
-0.000284
-0.000004
-0.00031
-0.000051
-0.000135
-0.000432
0.000027
-0.000501
-0.000219
-0.000212
-0.000296
-0.000169
-0.000226
-0.000015
-0.000371
-0.000213
-0.000185
-0.000368
-0.000088
-0.000219
-0.000133
-0.00016
-0.000195
-0.00013
-0.000366
-0.000152
-0.000344
-0.000136
-0.00022
-0.000212
-0.000088
-0.000261
-0.000074
-0.000184
-0.000166
-0.000113
-0.000168
-0.000204
-0.000133
-0.000167
-0.000222
-0.000041
-0.000294
-0.0003
-0.000072
-0.000249
-0.000179
-0.000027
-0.000215
-0.000126
-0.000051
-0.000353
-0.000037
-0.000186
-0.000312
-0.000088
-0.000195
-0.000252
-0.000149
-0.000127
-0.000444
-0.000122
-0.000112
-0.000366
0.000000
-0.000192
-0.000228
-0.00021
-0.000153
-0.000191
-0.000273
0.000047
-0.000493
-0.000268
-0.000141
-0.00037
-0.000079
-0.000319
-0.000152
-0.000237
-0.000074
-0.000152
-0.000358
-0.000146
-0.000475
-0.000082
-0.000275
-0.000298
-0.000087
-0.000375
0.000032
-0.000339
-0.000098
-0.000317
-0.000238
-0.000203
-0.000277
-0.000079
-0.000317
-0.000083
-0.000268
-0.000235
-0.000063
-0.00013
-0.000233
-0.000167
-0.000182
-0.000195
-0.000213
-0.000062
-0.00031
-0.000216
-0.000048
-0.000389
-0.000061
-0.0002
-0.000218
-0.00011
-0.000267
-0.000269
-0.000224
-0.000104
-0.000195
-0.000099
-0.00004
-0.000244
-0.000163
-0.000089
-0.000321
-0.000021
-0.00026
-0.000161
-0.000137
-0.000043
-0.00012
-0.00022
0.00002
-0.000161
-0.000086
-0.000051
-0.000149
-0.000108
-0.000167
-0.000073
-0.000228
-0.000141
-0.000149
-0.000251
-0.000005
-0.000248
-0.000164
-0.000067
-0.000151
-0.000068
-0.00033
-0.000067
-0.000082
-0.000109
-0.000073
-0.000187
-0.000048
-0.000135
-0.000154
-0.000173
-0.000118
-0.000021
-0.000215
0.00002
-0.000117
-0.000137
-0.000033
-0.00015
-0.000092
-0.000127
-0.000121
-0.000037
-0.000241
-0.000199
-0.000171
-0.000144
-0.000243
-0.000074
-0.000139
-0.000243
0.000007
-0.00026
-0.000155
-0.000109
-0.000203
-0.000179
-0.0002
-0.000072
-0.000085
-0.000083
-0.000113
-0.000284
-0.000008
-0.000163
-0.000099
-0.000247
-0.000164
-0.000137
-0.000324
-0.000051
-0.000239
-0.0002
-0.000059
-0.000027
-0.000218
-0.000079
0.000014
-0.00016
-0.00003
-0.000056
-0.000323
-0.000188
-0.000093
-0.000298
-0.000071
-0.00005
-0.000164
-0.000148
-0.000023
-0.000142
-0.000327
0.000035
-0.00033
-0.000086
-0.000058
-0.000367
-0.000044
-0.000196
0.000091
-0.000232
-0.000108
-0.000171
-0.000321
0.00002
-0.000356
0.000061
-0.000066
-0.000197
0.000031
-0.000128
-0.000133
-0.000188
0.000047
-0.000361
-0.000094
-0.000071
-0.000391
0.000246
-0.000281
-0.000248
-0.000019
-0.000142
-0.000143
-0.000089
-0.000001
-0.000221
0.000097
-0.000259
-0.000221
0.000069
-0.000253
-0.00012
0.000048
-0.00032
0.000026
-0.000151
-0.000157
-0.000136
0.000084
-0.000151
-0.000288
0.000012
-0.000345
0.000098
-0.000074
-0.000189
0.000083
-0.000224
-0.00016
-0.000086
-0.000082
-0.000301
-0.000074
-0.000062
-0.000288
-0.000063
-0.000044
-0.000131
0.000061
-0.000209
-0.000336
-0.00019
-0.000138
-0.000167
-0.00011
-0.000118
-0.000304
-0.000041
-0.000063
-0.000164
-0.00008
-0.000082
-0.000364
-0.000141
-0.000038
-0.000293
-0.000063
-0.000029
-0.000253
-0.000325
-0.000088
-0.000234
-0.000038
0.000022
-0.000231
-0.000209
-0.000089
-0.000145
-0.000168
-0.000107
-0.000091
-0.000209
-0.000087
-0.000161
-0.000159
-0.000069
-0.000215
-0.000189
-0.000107
-0.000063
-0.000011
-0.000155
-0.000121
-0.000191
-0.000041
-0.000099
-0.000071
-0.000106
-0.000174
-0.000038
-0.000148
0.000011
-0.000044
-0.000059
-0.000088
-0.000141
-0.0001
-0.00019
0.000019
-0.000292
-0.000245
-0.000017
-0.000014
0.000032
-0.000093
-0.000294
-0.000174
-0.000043
-0.000142
0.000046
-0.000081
-0.000101
-0.000137
-0.000035
-0.00017
-0.000097
0.00007
-0.000331
0.000031
-0.000283
-0.000359
-0.000068
0.000123
-0.000069
-0.00008
0.000013
-0.000388
-0.000182
-0.000031
-0.000177
-0.000036
-0.000232
0.000062
-0.000418
0.000213
-0.000326
-0.000189
0.00016
-0.000161
0.000136
-0.000475
-0.000062
0.00002
0.000105
0.000085
-0.000276
0.000022
-0.000471
-0.000088
-0.000085
-0.000077
-0.000076
-0.000116
-0.000118
-0.000153
-0.000067
-0.000235
-0.000132
-0.000112
-0.000144
0.000015
-0.000279
0.000015
-0.000174
0.000208
-0.000267
-0.000053
-0.000021
-0.000326
0.000076
-0.000251
-0.000074
-0.000302
-0.000065
-0.000251
-0.000247
0.000198
-0.000323
0.000023
-0.00004
-0.000114
-0.000163
-0.000273
-0.000022
-0.000267
0.000032
-0.000206
-0.000245
-0.000129
-0.00022
0.000204
-0.000135
-0.000143
-0.000292
-0.000117
-0.000145
-0.000095
0.000053
-0.000095
-0.000206
-0.000067
-0.000113
-0.00013
-0.000324
-0.000193
-0.000101
-0.000101
0.000052
-0.000349
-0.000257
-0.000254
-0.000083
0.000054
-0.000092
-0.000032
-0.000272
-0.000136
-0.000166
-0.000323
-0.000146
-0.000227
-0.000301
-0.000197
-0.0001
-0.000194
-0.000158
-0.000139
-0.000492
-0.000179
-0.000123
-0.000291
-0.000135
-0.000161
-0.000342
-0.0002
-0.000208
-0.000265
-0.000146
-0.000267
-0.000243
-0.000323
-0.000126
-0.000236
-0.000259
-0.000158
-0.000238
-0.000166
-0.000338
-0.000143
-0.000334
-0.000201
-0.000143
-0.000287
-0.000113
-0.000497
-0.000201
-0.000364
-0.000254
-0.000258
-0.000328
-0.000101
-0.000332
-0.000259
-0.000288
-0.000345
-0.000232
-0.000293
-0.000321
-0.000381
-0.000203
-0.000344
-0.00039
-0.000275
-0.000345
-0.000399
-0.000244
-0.000402
-0.000305
-0.000262
-0.000337
-0.000327
-0.00021
-0.00038
-0.000537
-0.000236
-0.000486
-0.000364
-0.000287
-0.000362
-0.000364
-0.000374
-0.000342
-0.000404
-0.000514
-0.000453
-0.000462
-0.000449
-0.000382
-0.000437
-0.000401
-0.000595
-0.000315
-0.000382
-0.000482
-0.000486
-0.000409
-0.000369
-0.000482
-0.000262
-0.000525
-0.000451
-0.000391
-0.000603
-0.000405
-0.000549
-0.000405
-0.000478
-0.000516
-0.000518
-0.000582
-0.00033
-0.000574
-0.000383
-0.000506
-0.000553
-0.000443
-0.000559
-0.00043
-0.000664
-0.000611
-0.00042
-0.000478
-0.000488
-0.0005
-0.000543
-0.000503
-0.00045
-0.000406
-0.000714
-0.000462
-0.000627
-0.000507
-0.000447
-0.000556
-0.000496
-0.000582
-0.000479
-0.000683
-0.000453
-0.000389
-0.000594
-0.000481
-0.000508
-0.000612
-0.000458
-0.000652
-0.000527
-0.000563
-0.00059
-0.000645
-0.00061
-0.000512
-0.000635
];

%% Charts output
%% Parameters
Fd=50;% Frequency [Hz]
Tm=length(Signal)/50;% Sgnal length [s]
FftL=Fd*20;% The number of FFT lines
Epsilon=50;% Maximum frequency zone [Hz]
%Signal = transpose(Signal(1:(Fd*Tm))); % Get the part of the signal

%% Signal spectrum
FftS=abs(fft(Signal,FftL));% FFT magnitudes
FftS=2*FftS./FftL;% FFT normalization
FftS(1)=FftS(1)/2;% FFT constant component

F=0:Fd/FftL:Fd/2-1/FftL;% FFT frequencies array
[C,i] = max(FftS);% FFT maximum

subplot(3,1,1);
plot(Signal);
title('Signal');
xlabel('Time(s)');
ylabel('Magnitude');

subplot(3,1,2);
semilogy(F,FftS(1:length(F)));
xlim([0 25]); 
title('Signal spectrum');
xlabel('Frequency(x 10 kHz)');
ylabel('Magnitude');

subplot(3,1,3);
plot(   F(max(1,i-Epsilon):min(length(F),i+Epsilon)),...
        FftS(max(1,i-Epsilon):min(length(F),i+Epsilon)),'-r',...
        F(i),FftS(i),'ko');
title('Signal spectrum');
xlabel('Frequency(x 10 kHz)');
ylabel('Magnitude');
