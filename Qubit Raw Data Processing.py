# -*- coding: utf-8 -*-
"""
Created on Thu Feb  1 14:49:54 2018

@author: clare
"""

import pandas as pd
import numpy as np

# Qubit's exported .csv file contains non UTF-8 characters, so save it as csv # UTF-8 first, and then use that conversed file for this code file
filename = input("Name of the file to be processed, include '.csv' please: ")
# Type in sample names, separate them by only one comma, no blank. Make sure
# samples names are not pure integers but contains letters and signs
samples = input("Type sample names in the order you quantified on Qubit, separate by ',': ")
samplenames = samples.split(',')
samplenumber = len(samplenames)
totalvolume = input("Type sample eluted volume (uL) in the order you quantified on Qubit, seperaed by ',': ")
totalvolume = totalvolume.split(',')
totalvolumes = list(totalvolume)
leftvolume = input("Type sample leftover volume (uL) after Qubit and Bioanalyzer in the order you quantified on Qubit, seperaed by ',': ")
leftvolume = leftvolume.split(',')
leftvolumes = list(leftvolume)
df = pd.read_csv(filename)
df = df.iloc[::-1]
df = df.set_index('Run ID')
read1 = []
read2 = []
read3 = []
moi = df.iloc[0]['Assay Name'].split(' ')
MoI = []
dilufact = int(input('Dilution factor of original samples: '))
for i in range(samplenumber):
    read1.append(df.iloc[i]['Original sample conc.'])
    read2.append(df.iloc[i+samplenumber]['Original sample conc.'])
    read3.append(df.iloc[i+2*samplenumber]['Original sample conc.'])
    MoI.append(moi[0])
SampleNames = list(samplenames)
dilutionfactor = np.array([dilufact]*samplenumber)
df2 = pd.DataFrame({'SampleNames': SampleNames, 'MoI': MoI, 'Read1':read1, 'Read2':read2, 'Read3':read3})
df2['std'] = df2.std(axis=1, numeric_only = True)
df2['Average (ng/uL)'] = (df2['Read1'] + df2['Read2'] + df2['Read3'])/3
df2['cv (%)'] = df2['std']/df2['Average (ng/uL)'] * 100
df2['Dilution Factor'] = dilutionfactor
df2['Original Sample Conc. (ng/uL)'] = df2['Average (ng/uL)']*df2['Dilution Factor']
df2['Total Volume (uL)'] = totalvolumes
df2['Leftover Volume (uL)'] = leftvolumes
df2['Total DNA (ng)'] = df2['Original Sample Conc. (ng/uL)']*df2['Total Volume (uL)'].astype(float)
df2['Leftover DNA (ng)'] = df2['Original Sample Conc. (ng/uL)']*df2['Leftover Volume (uL)'].astype(float)
df2 = df2.set_index('SampleNames')
# Generate current time as part of the saved file name so previous ones won't
# be overwritten
time = pd.Timestamp.now().strftime("%Y-%m-%d %H-%M-%S")
df2.to_csv(time + ' Calculated Qubit Conc' + '.csv', index = True)