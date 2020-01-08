import pandas as pd
import numpy as np

# read in the data
df = pd.read_csv('/Users/hayleeham/Documents/what-is-a-data-scientist/data/multipleChoiceResponses.csv', \
                 low_memory=False)

# remove that first row now
df = df.drop([0])

# remove students
df = df[df['Q7'] != 'I am a student']
df = df[df['Q6'] != 'Student']

# remove people who are data scientists but say they are not
df = df[(df['Q6'] != 'Data Scientist') | (df['Q26'] != 'Definitely not')]

# remove people who are Other or Not employed
df = df[(df['Q6'] != 'Other') & (df['Q6'] != 'Not employed')]

# change data type to numberic for all tasks
df['Q34_Part_1'] = pd.to_numeric(df['Q34_Part_1'])
df['Q34_Part_2'] = pd.to_numeric(df['Q34_Part_2'])
df['Q34_Part_3'] = pd.to_numeric(df['Q34_Part_3'])
df['Q34_Part_4'] = pd.to_numeric(df['Q34_Part_4'])
df['Q34_Part_5'] = pd.to_numeric(df['Q34_Part_5'])
df['Q34_Part_6'] = pd.to_numeric(df['Q34_Part_6'])

# Are you a data scientist?
df_yes = df[df['Q26'] == 'Definitely yes']
df_no = df[df['Q26'] == 'Definitely not']
df_probably_yes = df[df['Q26'] == 'Probably yes']
df_probably_not = df[df['Q26'] == 'Probably not']
df_maybe = df[df['Q26'] == 'Maybe']

# What is your title
job_titles = df['Q6'].value_counts().index
job_titles = job_titles[:-1]

top10 = ['Data Scientist', 'Software Engineer', 'Data Analyst',
       'Research Scientist', 'Consultant', 'Data Engineer',
       'Business Analyst', 'Manager', 'Research Assistant']

df_comp = df[['Q1', 'Q3', 'Q4', 'Q6', 'Q7', 'Q8', 'Q9', 'Q34_Part_1', 'Q34_Part_2', 'Q34_Part_3', 'Q34_Part_4', 'Q34_Part_5', 'Q34_Part_6']]
df_comp = df_comp.iloc[1:,]
df_comp = df_comp.dropna(subset=['Q8', 'Q9', 'Q34_Part_1'])
df_comp = df_comp[df_comp['Q9'] != 'I do not wish to disclose my approximate yearly compensation']
df_comp = df_comp[df_comp['Q7'] != 'I am a student']

# create gender bool
df_comp['female'] = 0
df_comp.loc[df_comp['Q1'] == 'Female', 'female'] = 1

# create country bools
df_comp['usa'] = 0
df_comp.loc[df_comp['Q3'] == 'United States of America', 'usa'] = 1
df_comp['india'] = 0
df_comp.loc[df_comp['Q3'] == 'India', 'india'] = 1
df_comp['china'] = 0
df_comp.loc[df_comp['Q3'] == 'China', 'china'] = 1
df_comp['other_country'] = 0
df_comp.loc[(df_comp['Q3'] != 'United States of America') & (df_comp['Q3'] != 'India') & (df_comp['Q3'] != 'China'), 'other_country'] = 1

# create education level bools
df_comp['bachelors'] = 0
df_comp.loc[df_comp['Q4'] == "Bachelor’s degree", 'bachelors'] = 1
df_comp['masters'] = 0
df_comp.loc[df_comp['Q4'] == "Master’s degree", 'masters'] = 1
df_comp['phd'] = 0
df_comp.loc[df_comp['Q4'] == "Doctoral degree", 'phd'] = 1
df_comp['pro'] = 0
df_comp.loc[df_comp['Q4'] == "Professional degree", 'pro'] = 1
df_comp['no_bach'] = 0
df_comp.loc[(df_comp['Q4'] != "Professional degree") & (df_comp['Q4'] != "Bachelor’s degree") & (df_comp['Q4'] != "Master’s degree") & (df_comp['Q4'] != "Doctoral degree"), 'no_bach'] = 1

# create industry bools
df_comp['tech'] = 0
df_comp.loc[df_comp['Q7'] == 'Computers/Technology', 'tech'] = 1
df_comp['academia'] = 0
df_comp.loc[df_comp['Q7'] == 'Academics/Education', 'academia'] = 1
df_comp['other_industry'] = 0
df_comp.loc[(df_comp['Q7'] != 'Academics/Education') & (df_comp['Q7'] != 'Computers/Technology'), 'other_industry'] = 1

# create years of exp ints
df_comp.loc[df_comp['Q8'] == '0-1', 'exp'] = 0
df_comp.loc[df_comp['Q8'] == '1-2', 'exp'] = 1
df_comp.loc[df_comp['Q8'] == '2-3', 'exp'] = 2
df_comp.loc[df_comp['Q8'] == '3-4', 'exp'] = 3
df_comp.loc[df_comp['Q8'] == '4-5', 'exp'] = 4
df_comp.loc[df_comp['Q8'] == '5-10', 'exp'] = 5
df_comp.loc[df_comp['Q8'] == '10-15', 'exp'] = 6
df_comp.loc[df_comp['Q8'] == '15-20', 'exp'] = 7
df_comp.loc[df_comp['Q8'] == '20-25', 'exp'] = 8
df_comp.loc[df_comp['Q8'] == '25-30', 'exp'] = 9
df_comp.loc[df_comp['Q8'] == '30 +', 'exp'] = 10

# dummies for job titles
job_titles = pd.get_dummies(df_comp['Q6'])
job_titles = job_titles[top10]
df_comp = pd.concat([df_comp, job_titles], axis=1)
df_comp['other_job'] = 0
df_comp.loc[~df_comp['Q6'].isin(pd.Series(top10)), 'other_job'] = 1 

# rename time spent variables
df_comp = df_comp.rename(columns={'Q34_Part_1': 'gather_data', 'Q34_Part_2': 'clean_data', 'Q34_Part_3': 'data_viz',
                        'Q34_Part_4': 'build_model', 'Q34_Part_5': 'model_prod', 'Q34_Part_6': 'comm_insights'})


# regress compensation on how spend time
# string to int for compensation level categories
# pd.Categorical(df_comp['Q9'])
comps = ['0-10,000', '10-20,000', '20-30,000', '30-40,000', 
         '40-50,000', '50-60,000', '60-70,000', '70-80,000',
         '80-90,000', '90-100,000', '100-125,000', '125-150,000',
         '150-200,000', '200-250,000', '250-300,000', '300-400,000',
         '400-500,000', '500,000+']

df_comp['y'] = df_comp['Q9'].astype(pd.api.types.CategoricalDtype(categories=comps)).cat.codes

# change names of job bools
df_comp = df_comp.rename(columns={'Data Scientist': 'data_sci', 'Software Engineer': 'software_eng',
       'Data Analyst': 'data_ana', 'Research Scientist': 'r_sci', 'Consultant': 'consultant', 
        'Data Engineer': 'data_eng', 'Business Analyst': 'bus_ana', 
        'Manager': 'manager', 'Research Assistant': 'r_ast'})

# df_comp['average_comp'] = None
df_avg_comp = pd.DataFrame(data={'Q9': comps, 'avg': [5000, 15000, 25000, 35000, 45000, 55000, 65000, 75000,
                                                     85000, 95000, 112500, 137500, 175000, 225000, 275000,
                                                     350000, 450000, 550000]})
df_comp = df_comp.merge(df_avg_comp, on='Q9')

# run this in R
df_comp.to_csv('data/compensation_data.csv')

# now filter it to include only top 10 jobs
df_comp_10 = df_comp[df_comp['Q6'].isin(top10)]

# run this in R
df_comp_10.to_csv('data/compensation_data_10.csv')

# now only include US
df_comp_us = df_comp[df_comp['usa'] == 1]
df_comp_us.to_csv('data/compensation_data_usa.csv')