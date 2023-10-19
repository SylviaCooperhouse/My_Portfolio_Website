# My_Portfolio_Website
Sylvia's Data Science Project Portfolio

# [Project 1: Diamond Price Estimation Data Analysis](https://github.com/SylviaCooperhouse/dimond-price-analysis)

In this project, I conducted a comprehensive analysis of diamond pricing using a Kaggle dataset, aiming to build an accurate pricing model based on various attributes like carat weight, cut quality, color, clarity, and dimensions. Employing Python and libraries such as pandas, matplotlib, seaborn, and scikit-learn, I performed exploratory data analysis, visualization, and developed predictive models including Linear Regression, Polynomial Regression, and Random Forest Regression. The Random Forest model achieved remarkable accuracy, explaining 98.14% of price variance. I also created a user-friendly Flask API enabling real-time price predictions based on user input. Explore key visualizations highlighting price distributions, correlations, and more below. This project serves as a valuable resource for consumers, jewelers, and industry professionals interested in diamond pricing dynamics and predictive modeling techniques.
<table>
  <tr>
    <td><img src="images/Actual%20Prices%20vs.%20Predicted%20Prices%20(Random%20Forest).png" alt="Actual vs. Predicted"></td>
    <td><img src="images/Random%20Forest%20Feature%20Importance.png" alt="Feature Importance"></td>
  </tr>
</table>


# [Project 2: Sample SQL Functions](https://github.com/SylviaCooperhouse/My_Portfolio_Website/tree/main/SQL%20function%20Samples)

1. Function Name: public.update_table_records()
Description: This PostgreSQL function is designed to track changes in tables within a specified PostgreSQL schema. It inserts new tables into a tracking table and deletes records for tables that no longer exist. This is a valuable tool for monitoring changes in a database schema and maintaining an up-to-date record of tables.
Key Features:
Checks the environment to control execution.
Inserts newly created tables into a tracking table (public.reported_tables).
Deletes records for tables that have been removed from the schema.
Ensures the function is run as an event trigger when tables are created or dropped (CREATE TABLE or DROP TABLE events).
This function provides a valuable mechanism for keeping track of changes to database tables, which is essential for maintaining data integrity and schema management.
User Activity Tracking Function

2. Function Name: schema.track_daily_user_count
Description: This PostgreSQL function is used to track daily user counts and user actions within a specified date range. It accepts start and end dates as parameters and operates on a user records table. For each day in the given range, it calculates and records the number of users and their actions. The results are stored in the schema.track_daily_user_count table. If any records fall outside the specified date range, they are removed. This function is designed for monitoring user activity over time.
This versatile function can be integrated into various applications to monitor user engagement and activity trends while ensuring data accuracy.
These descriptions provide clear and consistent information about the purpose and functionality of each PostgreSQL function.


# [Project 3: Sample SQL Functions](https://public.tableau.com/app/profile/sylvia.cooperhouse/vizzes)

[**HR Analytics Dashboard**](https://public.tableau.com/shared/GHFZ7BP76?:display_count=n&:origin=viz_share_link)
![HR Analytics Dashboard](images/Actual%20Prices%20vs.%20Predicted%20Prices%20(Random%20Forest).png)

