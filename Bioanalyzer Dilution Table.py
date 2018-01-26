# -*- coding: utf-8 -*-
"""
Created on Fri Jan 26 11:33:20 2018

@author: clare
"""

import numpy as np
import pandas as pd
### Type in name of a csv file that includes 'Sample Name', 'MoI',	'Conc of Samples (ng/uL)', and	'Used Sample Volume (ul)'. You need to get these four columns' content via manually process raw Qubit reads in an excel workbook, pick these four types of information for a new tab in the workbook, and save that tab of sheet as csv

filename = input("Name of the file to be processed, including '.csv': ")
samplefiledf = pd.read_csv(filename)

### The following code calculates the needed information to dilute samples to meet Bioanalyzer's requirements, i.e. concentration <= 0.5 ng/uL (We always aim for slightly higher or equal to 0.5), diluted total volume > 6 uL (Bioanalyzer needs 4 uL per sample, 2 uL additional ensures accurate pipetting. If 'Total over 6?') = False, you need to manually scale the calculated values up, e.g. double or triple it will be an easy solution

samplefiledf['Diluted Total Vol (uL)'] = samplefiledf['Conc of Samples (ng/uL)'] * samplefiledf['Used Sample Volume (ul)']/0.5
samplefiledf['Added EB Volume (uL)'] = samplefiledf['Diluted Total Vol (uL)'] - samplefiledf['Used Sample Volume (ul)']
samplefiledf['Added EB Volume (uL)']=samplefiledf['Added EB Volume (uL)'].astype('int')
samplefiledf['Total (uL)'] = samplefiledf['Used Sample Volume (ul)'] + samplefiledf['Added EB Volume (uL)']
samplefiledf['Final Conc (ng/uL)'] = samplefiledf['Conc of Samples (ng/uL)'] * samplefiledf['Used Sample Volume (ul)']/samplefiledf['Total (uL)']
samplefiledf['Total over 6?'] = samplefiledf['Total (uL)'] >= 6
samplefiledf['Sample Sub ID'] = samplefiledf.index.values + 1
### You can uncomment the following statement to check if the dataframe is correctly processed
#print(samplefiledf)

filenameout = filename.split('.')
samplefiledf.to_csv(filenameout[0] + ' Calculated Dilution' + '.csv', index = False)