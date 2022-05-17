import streamlit as st
import pandas as pd
from xgboost import XGBRegressor
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_absolute_error
import numpy as np
import time


df = pd.read_csv('housing.csv')

st.sidebar.header("Конфигурация")
option = st.sidebar.selectbox("Выберите размер тест выборки, в процентах", [10, 15, 20, 25, 30, 35])
st.sidebar.write(f'Вы выбрали: {option}')

if st.button('Отобразить первые пять строк'):
    st.write(df.head())
    
    
if st.button('Обучить модель'):
            st.write(f'Расчет модeли с размером выборки: {option} процентов')
            X_train, X_test, y_train, y_test = train_test_split(df.drop('MEDV', axis=1),
                                                                df['MEDV'],
                                                                test_size=option,
                                                                random_state=2100)
            st.write('Разделили данные и передали в обучение')
            regr_model = XGBRegressor()
            regr_model.fit(X_train, y_train)
            pred = regr_model.predict(X_test)
            st.write('Обучили модель, MAE = ' + str(mean_absolute_error(y_test, pred)))
            st.write('Результат предсказания:')
            df_pred = pd.DataFrame({'MEDV':y_test, 'pred': pred})
            df_pred['pred'] = df_pred['pred'].astype('float').round(1)
            st.dataframe(df_pred.reset_index(drop=True))