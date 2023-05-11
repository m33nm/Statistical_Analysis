# HIV Statistical_Analysis
HIV Mortality Rate in Sub-Saharan African (SSA) Countries is a study that analyzed and compared the HIV mortality rate in least developed and developed SSA 
countries over 10 years using R programming language.
	The HIV mortality rate was analysed based on the epidemic record situation in the region. Least developed countries often time face more epidemic
	challenges compared to the developed countries. The statistical analysis accessed the data to provide insights to the epidemic challenge.

The study focused on the following sub-objectives to statistically analyze the mortality rate of HIV in the ten selected countries using the RStudio
computing environment.

1. Statistically describe the obtained HIV mortality dataset.
2. Evaluate the relationship between the dataset variables as they relate to the mortality rate among the countries. (Correlation Analysis)
3. Develop a prediction model for the linear relationship to predict the HIV mortality rate. (Regression Analysis)
4. Analyze the HIV mortality rate occurrences over the years and develop a model to predict future values. (Time Series Analysis)
5. Compare the HIV mortality rate among SSA’s least developed and developed countries. (Comparative Analysis)
# Result Analysis
_**Correlation Analysis**_

![image](https://github.com/m33nm/Statistical_Analysis/assets/54365936/925cc6ed-9f29-4648-9f58-3368c87a06e5)

Figure 1: Correlation between dataset indicators

The correlation matrix (Figure 1) shows the correlation coefficients between the dataset variables
as they relate to the HIV mortality rate. It revealed that the correlation between the number of
deaths “Deaths” and the population newly infected with HIV “PNIWH” is 0.97, which indicates
that they are strongly positively correlated. This result supports the UNAIDS (2022c) report that
most people who died from HIV were newly infected and unaware of their HIV status. The matrix
also shows that the correlation between the number of deaths “Deaths” and the population living
with HIV “PLWH” is 0.93, which indicates that they are strongly positively correlated. It also
supports the UNAIDS’s finding that many people living with HIV die without adequate treatment. The correlation between
“Deaths” and “ART PLWH” is 0.07, indicating that they’re not correlated. There is little association
between the number of deaths and the population enrolled in antiretroviral therapy. This finding
supports the UNAIDS report that getting adequate treatment could extend the life span of people
with the disease.


_**Regression Analysis**_

The regression analysis examines the possible linear relation between deaths by AIDS and other
independent variables (IV) in the dataset to develop a prediction model for the mortality rate.
From the correlation matrix above (Figure 1), only two indicators (PLWH & PNIWH) have a high
correlation with the dependent variable (DV/Deaths). It is important to note that the correlation
result (Figure 1) is for the least developed and developed countries in the selected ten SSA
countries.
It is known that rural areas differ from urban areas in geographical regions. Thus, I selected a case
study of the least developed countries in the dataset to develop a more specific model for
predicting the HIV mortality rate in the region.

![image](https://github.com/m33nm/Statistical_Analysis/assets/54365936/e211f17c-53b0-48c9-b1ea-25714e3bf0cc)

Figure 2: Correlation matrix for five least developed SSA countries

The correlation in Figure 2 revealed a strong negative relationship between the HIV mortality
rate and undernourished people in the selected least-developed countries. This result implies
that malnutrition in these regions decreases as HIV-related deaths increase and vice versa. 

A Multiple Linear Regression (MLR) model was developed with an Adjusted R-squared value of 0.91, indicating that the fitted regression line can predict 91% of the HIV
mortality rate in the least developed region based on the number of people newly infected with the disease, the number of
pregnant women carriers enrolled in care, and the number of malnourished people.


_**Time Series Analysis**_

Using a case study of Ghana, one of the least developed SSA countries in the dataset, the time series
analysis was used to predict the HIV mortality rate of Ghana in the next ten years

![image](https://github.com/m33nm/Statistical_Analysis/assets/54365936/82bca524-4937-4862-b334-22cb7406292c)

Figure 3: HIV mortality rate forecast for the Ghana time series

The blue line in Figure 3 represents the forecasts with prediction intervals at 80% as
a purple-shaded area and 95% as a gray-shaded area. It predicts a steady reduction in the HIV
mortality rate in Ghana come 2030.

_**Comparative Analysis**_

A Wilcoxon test was applied to compare the mortality rate between the two regions. The null and alternative hypotheses of the Wilcoxon test are as follows:

H0: median population of HIV mortality rate of SSA’s least developed and developed countries is
equal

H1: median population of HIV mortality rate of SSA’s least developed and developed countries is
different

![image](https://github.com/m33nm/Statistical_Analysis/assets/54365936/6ca2aa3f-579b-4717-9bce-9cba1e1dc6a2)

Figure 4: Wilcoxon test with plot and statistical result

The p-value is 0.00365. Therefore, at a 0.05 significance level, there is no sufficient evidence to
accept the null hypothesis. Thus we conclude that HIV mortality rates among SSA’s least
developed and developed countries are significantly different.

# Conclusions
The findings of each analysis phase, as stated in the objectives, are:
1. Descriptive analysis: the dataset has numerical and categorical variables, potential
outliers, unequal variances, and no missing data. The DV distribution was right-skewed
and leptokurtic.
2. Correlation analysis: the variables have varying correlations. Infected & Newly infected
Persons had a strong positive correlation with DV (HIV Deaths); Pregnant Women in Care
had a weak correlation; Other infected & Malnourished Persons had insignificant or no
correlation with DV.
3. Regression analysis: three combined IVs resulted in the highest adjusted R2 value of 0.91
and were used to fit the prediction model. All MLR assumptions were approved, and the
fitted regression line for the selected least developed countries in SSA is: “Mortality rate
(HIV Deaths) = 1.594 + 0.5468 x PNIWH + 0.001324 x ART.PMTCT.LWH – 0.00000002706
x Undernourished”
4. Time series: The Ljung-Box test statistic for the Ghana time series was 5.8, with a p-value
of 0.7, indicating little evidence of non-zero autocorrelations in the in-sample forecast
errors at lags 1-8. Holt-Winters exponential smoothing provides an adequate predictive
model of the HIV mortality rate in Ghana with a decreasing trend in the next ten years.
5. Comparative analysis: the Wilcoxon test was applied at a 5% significance level. With a pvalue
of 0.00365, we concluded that HIV mortality rates among SSA’s least developed and
developed countries are significantly different.
