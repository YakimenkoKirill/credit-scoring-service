```mermaid
erDiagram
    Application ||--o{ Bureau : "SK_ID_CURR"
    Application ||--o{ PrevApp : "SK_ID_CURR"
    Application ||--o{ CreditCard : "SK_ID_CURR"
    Application ||--o{ PosCash : "SK_ID_CURR"
    Application ||--o{ Installments : "SK_ID_CURR"
    Application ||--|| SampleSub : "SK_ID_CURR"
    
    Bureau ||--o{ BureauBalance : "SK_ID_BUREAU"
    
    PrevApp ||--o{ CreditCard : "SK_ID_PREV"
    PrevApp ||--o{ PosCash : "SK_ID_PREV"
    PrevApp ||--o{ Installments : "SK_ID_PREV"
    
    ColDesc }o--|| Application : "описывает поля"

    Application["application_train_or_test"] {
        int SK_ID_CURR PK
        int TARGET
        string NAME_CONTRACT_TYPE
    }
    Bureau["bureau"] {
        int SK_ID_CURR FK
        int SK_ID_BUREAU PK
    }
    BureauBalance["bureau_balance"] {
        int SK_ID_BUREAU FK
        int MONTHS_BALANCE
        string STATUS
    }
    PrevApp["previous_application"] {
        int SK_ID_PREV PK
        int SK_ID_CURR FK
    }
    CreditCard["credit_card_balance"] {
        int SK_ID_PREV FK
        int SK_ID_CURR FK
    }
    PosCash["POS_CASH_balance"] {
        int SK_ID_PREV FK
        int SK_ID_CURR FK
    }
    Installments["installments_payments"] {
        int SK_ID_PREV FK
        int SK_ID_CURR FK
    }
    SampleSub["sample_submission"] {
        int SK_ID_CURR PK
        int TARGET
    }
    ColDesc["HomeCredit_columns_description"] {
        string Table
        string Row
        string Description
        string Special
    }
```
| Name                  | Table                                                                                                                                                       |
| --------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| application_train     | one row per client with the full loan application profile (income, credit, demographics, external scores) and the binary `TARGET` label indicating default. |
| bureau                | one row per client's credit account at other banks (credit type, status, amounts, overdue, duration).                                                       |
| bureau_balance        | monthly status history of each bureau credit account, showing delinquency progression over time.                                                            |
| credit_card_balance   | monthly per-card balance, limit, spending, payment, and overdue (DPD) history for each client's credit cards.                                               |
| installments_payments | one row per scheduled installment with planned vs actual payment dates and amounts, revealing lateness and underpayment.                                    |
| POS_CASH_balance      | monthly snapshot of each POS/cash loan showing remaining installments, contract status, and days past due.                                                  |
| previous_application  | one row per client's prior loan application at Home Credit (amounts, status, decision, channel, product terms).                                             |
| sample_submission     | submission template with `SK_ID_CURR` from test and an empty `TARGET` column to fill with predicted default probabilities.                                  |