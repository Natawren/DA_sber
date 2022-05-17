import streamlit as st
import pandas as pd
from xgboost import XGBRegressor
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_absolute_error
import numpy as np
import time

df = pd.read_csv('housing.csv')


if st.button('Отобразить первые пять строк'):
    st.write(df.head())
button1 = st.button('Обучить модель')
if st.session_state.get('button') != True:
    st.session_state['button'] = button1   
if st.session_state['button'] == True:
        with st.form(key='my_form'):
            option = st.selectbox("Выберите размер тест выборки, в процентах", [10, 15, 20, 25, 30, 35])
            submit_button = st.form_submit_button(label=f'Submit')
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
