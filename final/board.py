import sqlite3
import streamlit as st
import pandas as pd

conn = sqlite3.connect('test_database')
c = conn.cursor()
df = pd.io.sql.read_sql("""select * from prediction""", conn)

st.title("Информация о тестовой выборке", anchor=None)
button1 = st.button('Показать количество фродовых трансакций')
if st.session_state.get('button') != True:
    st.session_state['button'] = button1 
if st.session_state['button'] == True:
    with st.form(key='my_form'):
            option = st.selectbox("Выберите период", ["неделя", "месяц", "3 месяца", "6 месяцев"])
            submit_button = st.form_submit_button(label=f'Submit')
    period_dict = {"неделя":7, "месяц":30, "3 месяца":80, "6 месяцев":180}
    df_fraud_week = df[(df.step > (df.step.max() - period_dict[option])) & (df.fraud == 1)]
    st.write(len(df_fraud_week))
    
if  st.button("Показать последние 10 трансакций, требующие проверки"):
    if len(df[df.fraud_basic == 1]) >= 10:
        st.write(df[df.fraud_basic == 1].tail(10))
    else: st.write("В датафрейме меньше, чем 10 трансакций, требующих проверки")