import yfinance as yf
import pandas as pd
from pandas_datareader import data as pdr
from bs4 import BeautifulSoup
import numpy as np

class Currency():
	def __init__(self, flag):
		self.flag = flag
		self.currency_base = {'currency_yahoo': self.currency_yahoo,
							  'currency_cb':self.currency_cb}

	def currency_yahoo(self):
		usd = yf.Ticker("USDrub=X")
		euro = yf.Ticker("EURrub=X")
		oil = yf.Ticker("BZ=F") #in dollar

		usd_hist = usd.history(period="max")
		euro_hist = euro.history(period="max")
		oil_hist = oil.history(period="max")

		df = (usd_hist[["Close"]].merge(euro_hist[["Close"]],on='Date',how='left', suffixes=('_usd', '_euro'))
				   .merge(oil_hist[["Close"]], on='Date', how='left')
				   .rename(columns={"Close": "Close_oil"}))
		df = df[df['Close_oil'].notna()]
		return df

	def currency_cb(self):
		pass

	def result_currency(self):
		return self.currency_base[self.flag]()

class Customer():

	def __init__(self, PRODUCTION_COST, EU_LOGISTIC_COST_EUR, CN_LOGISTIC_COST_USD, customers, discounts, destinaton_costs, flag):
		self. PRODUCTION_COST = PRODUCTION_COST
		self.EU_LOGISTIC_COST_EUR = EU_LOGISTIC_COST_EUR
		self.CN_LOGISTIC_COST_USD = CN_LOGISTIC_COST_USD
		self.customers = customers
		self.discounts = discounts
		self.destinaton_costs = destinaton_costs
		self.flag = flag

	def _dictionary(self, df):

		d_comment = { 'moving_average_usd': df['Close_usd'].rolling(window=100).mean().tail(1)[0],
					'moving_average_euro': df['Close_euro'].rolling(window=100).mean().tail(1)[0],
					'moving_average_oil': df['Close_oil'].rolling(window=100).mean().tail(1)[0],
					'monthly_usd' : df['Close_usd'].tail(n=30).mean(),
					'monthly_euro': df['Close_euro'].tail(n=30).mean(),
					'monthly_oil' : df['Close_oil'].tail(n=30).mean()}
		loc = {'EU' : '_euro', 'CN': '_usd'}
		return d_comment, loc
	

	def all_clients(self):
		df_customers = pd.DataFrame.from_dict(self.customers, orient='index')
		cur = Currency(self.flag)
		df = cur.result_currency()
		d_comment, loc = self._dictionary(df)
		df_customers['log_rub'] = (df_customers.apply(lambda x: self.destinaton_costs[x['location']]*d_comment[(x.comment+loc[x.location])],axis=1))
		df_customers['disc_price'] =  np.where(df_customers.volumes < 100, self.discounts['up to 100'],
											(np.where(df_customers.volumes > 300, self.discounts['300 plus'], self.discounts['up to 300'])))
		df_customers['production_rub'] = (df_customers.apply(lambda x: 400*d_comment[(x.comment+'_euro')] + 16*d_comment[(x.comment+'_oil')]*d_comment[(x.comment+'_usd')], axis = 1))
		df_customers['result_price'] = df_customers.eval(df_customers.log_rub + df_customers.production_rub * df_customers.volumes * df_customers.disc_price)
		return df_customers