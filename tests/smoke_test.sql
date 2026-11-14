-- Smoke test for database/schema.sql
-- Loads a small, consistent data set and checks every view, function and stored procedure.
-- Any wrong result raises an error, so `sqlcmd -b` exits with a failure code.

USE Milestone2DB_24;
GO
SET NOCOUNT ON;
GO

------------------------------------------------------------------------------
-- Sample data
------------------------------------------------------------------------------
INSERT INTO customer_profile VALUES
 (1, 'Mariam', 'Ali',    'mariam@example.com', 'Cairo', '2000-01-01'),
 (2, 'Omar',   'Hassan', 'omar@example.com',   'Giza',  '1999-05-12');

INSERT INTO customer_account VALUES
 ('01000000001', 'pw1', 100.0, 'prepaid',  '2023-01-01', 'active', 0, 1),
 ('01000000002', 'pw2',  50.0, 'postpaid', '2023-01-01', 'onhold', 0, 2);

INSERT INTO Service_plan (name, price, SMS_offered, minutes_offered, data_offered, description) VALUES
 ('Basic Plan',   100, 100,  500, 10, 'Basic'),      -- planID 1
 ('Premium Plan', 300, 500, 1500, 50, 'Premium');    -- planID 2

INSERT INTO Subscription VALUES
 ('01000000001', 1, '2023-01-01', 'active'),
 ('01000000001', 2, CAST(GETDATE() AS date), 'onhold');

INSERT INTO Plan_Usage (start_date, end_date, data_consumption, minutes_used, SMS_sent, mobileNo, planID) VALUES
 ('2023-01-05', '2023-01-20', 5, 100, 20, '01000000001', 1),
 (CAST(GETDATE() AS date), CAST(GETDATE() AS date), 2, 30, 5, '01000000001', 2);

INSERT INTO Payment (amount, date_of_payment, payment_method, status, mobileNo) VALUES
 (100.0, DATEADD(year, -1, GETDATE()), 'cash',   'successful', '01000000001'),   -- paymentID 1
 ( 50.0, DATEADD(year, -1, GETDATE()), 'credit', 'successful', '01000000001'),   -- paymentID 2
 (300.0, DATEADD(year, -1, GETDATE()), 'cash',   'rejected',   '01000000002');   -- paymentID 3

INSERT INTO process_payment (paymentID, planID) VALUES (1, 1), (2, 2);

INSERT INTO Wallet (current_balance, currency, last_modified_date, nationalID, mobileNo) VALUES
 (100.00, 'egp', '2023-01-01', 1, '01000000001'),   -- walletID 1
 ( 20.00, 'egp', '2023-01-01', 2, '01000000002');   -- walletID 2

INSERT INTO transfer_money (walletID1, walletID2, amount, transfer_date) VALUES
 (1, 2, 40, '2023-03-01'),
 (1, 2, 60, '2023-03-10');

INSERT INTO Benefits (description, validity_date, status, mobileNo) VALUES
 ('Loyalty points', '2030-01-01', 'active',  '01000000001'),   -- benefitID 1
 ('SMS bonus',      '2030-01-01', 'active',  '01000000001'),   -- benefitID 2
 ('Old cashback',   '2020-01-01', 'expired', '01000000002');   -- benefitID 3

INSERT INTO Points_group (benefitID, pointsAmount, paymentId) VALUES (1, 30, 1), (1, 20, 2);

INSERT INTO Exclusive_offer (benefitID, internet_offered, SMS_offered, minutes_offered) VALUES
 (2, 5, 100, 0),
 (1, 1,   0, 10);

INSERT INTO Cashback (benefitID, walletID, amount, credit_date) VALUES
 (1, 1, 10, '2023-02-01'),
 (3, 2,  5, '2023-02-01');

INSERT INTO plan_provides_benefits (benefitid, planID) VALUES (1, 1), (2, 1);

INSERT INTO shop (name, Category) VALUES ('Online Store', 'Electronics'), ('City Market', 'Groceries');
INSERT INTO E_shop VALUES (1, 'https://store.example.com', 5);
INSERT INTO Physical_shop VALUES (2, 'Maadi, Cairo', '9:00-22:00');

INSERT INTO Voucher (value, expiry_date, points, mobileNo, redeem_date, shopid) VALUES
 (50, '2030-01-01', 40, '01000000001', NULL, 1),   -- voucherID 1
 (80, '2030-01-01', 60, '01000000001', NULL, 2),   -- voucherID 2
 (20, '2030-01-01', 10, NULL,          NULL, 1);   -- voucherID 3 (not redeemed yet)

INSERT INTO Technical_support_ticket (mobileNo, issue_description, priority_level, status) VALUES
 ('01000000001', 'No signal', 1, 'Open'),
 ('01000000001', 'Billing',   2, 'Resolved');
GO

------------------------------------------------------------------------------
-- Views
------------------------------------------------------------------------------
IF (SELECT COUNT(*) FROM allCustomerAccounts)   <> 1 THROW 50001, 'allCustomerAccounts should list only active accounts', 1;
IF (SELECT COUNT(*) FROM allServicePlans)       <> 2 THROW 50002, 'allServicePlans', 1;
IF (SELECT COUNT(*) FROM allBenefits)           <> 2 THROW 50003, 'allBenefits should list only active benefits', 1;
IF (SELECT COUNT(*) FROM AccountPayments)       <> 3 THROW 50004, 'AccountPayments', 1;
IF (SELECT COUNT(*) FROM allShops)              <> 2 THROW 50005, 'allShops', 1;
IF (SELECT COUNT(*) FROM allResolvedTickets)    <> 1 THROW 50006, 'allResolvedTickets', 1;
IF (SELECT COUNT(*) FROM CustomerWallet)        <> 2 THROW 50007, 'CustomerWallet', 1;
IF (SELECT COUNT(*) FROM E_shopVouchers)        <> 2 THROW 50008, 'E_shopVouchers', 1;
IF (SELECT COUNT(*) FROM PhysicalStoreVouchers) <> 1 THROW 50009, 'PhysicalStoreVouchers', 1;
IF (SELECT COUNT(*) FROM Num_of_cashback)       <> 2 THROW 50010, 'Num_of_cashback', 1;
PRINT 'PASS  10 views';
GO

------------------------------------------------------------------------------
-- Functions
------------------------------------------------------------------------------
IF (SELECT COUNT(*) FROM dbo.Account_Plan_date('2023-01-01', 1)) <> 1 THROW 50101, 'Account_Plan_date', 1;
IF (SELECT COUNT(*) FROM dbo.Account_Usage_Plan('01000000001', '2023-01-01')) <> 2 THROW 50102, 'Account_Usage_Plan', 1;
IF (SELECT COUNT(*) FROM dbo.Account_SMS_Offers('01000000001')) <> 1 THROW 50103, 'Account_SMS_Offers', 1;
IF dbo.Wallet_Cashback_Amount(1, 1) <> 10 THROW 50104, 'Wallet_Cashback_Amount', 1;
IF dbo.Wallet_Transfer_Amount(1, '2023-03-01', '2023-03-31') <> 50 THROW 50105, 'Wallet_Transfer_Amount (average)', 1;
IF dbo.Wallet_MobileNo('01000000001') <> 1 OR dbo.Wallet_MobileNo('01999999999') <> 0 THROW 50106, 'Wallet_MobileNo', 1;
IF dbo.AccountLoginValidation('01000000001', 'pw1') <> 1 OR dbo.AccountLoginValidation('01000000001', 'wrong') <> 0 THROW 50107, 'AccountLoginValidation', 1;
IF (SELECT COUNT(*) FROM dbo.Consumption('Basic Plan', '2023-01-01', '2023-01-31')) <> 1 THROW 50108, 'Consumption', 1;
IF (SELECT COUNT(*) FROM dbo.Usage_Plan_CurrentMonth('01000000001')) < 1 THROW 50109, 'Usage_Plan_CurrentMonth', 1;
IF (SELECT COUNT(*) FROM dbo.Cashback_Wallet_Customer(1)) <> 1 THROW 50110, 'Cashback_Wallet_Customer', 1;
IF dbo.Remaining_plan_amount('01000000001', 'Premium Plan') <> 250 THROW 50111, 'Remaining_plan_amount', 1;
IF dbo.Extra_plan_amount('01000000001', 'Premium Plan') <> 0 THROW 50112, 'Extra_plan_amount', 1;
IF dbo.Remaining_plan_amount('01000000001', 'Basic Plan') <> 0 THROW 50113, 'Remaining_plan_amount (fully paid)', 1;
IF (SELECT COUNT(*) FROM dbo.Subscribed_plans_5_Months('01000000001')) <> 1 THROW 50114, 'Subscribed_plans_5_Months', 1;
IF (SELECT remaining_amount FROM process_payment WHERE paymentID = 2) <> 250 THROW 50115, 'process_payment.remaining_amount (computed column)', 1;
PRINT 'PASS  15 functions (including the two used by computed columns)';
GO

------------------------------------------------------------------------------
-- Stored procedures
------------------------------------------------------------------------------
CREATE TABLE #two_ints (a int, b int);
CREATE TABLE #one_int (a int);
CREATE TABLE #payments (paymentID int, amount decimal(10,1), date_of_payment date, payment_method varchar(50), status varchar(50), mobileNo char(11));
CREATE TABLE #plans (planID int, name varchar(50), price int, SMS_offered int, minutes_offered int, data_offered int, description varchar(50));

EXEC Account_Plan;

INSERT INTO #two_ints EXEC Account_Payment_Points @mobile_num = '01000000001';
IF NOT EXISTS (SELECT 1 FROM #two_ints WHERE a = 2 AND b = 50) THROW 50201, 'Account_Payment_Points', 1;

INSERT INTO #one_int EXEC Ticket_Account_Customer @NID = 1;
IF (SELECT a FROM #one_int) <> 1 THROW 50202, 'Ticket_Account_Customer', 1;
DELETE FROM #one_int;

INSERT INTO #one_int EXEC Account_Highest_Voucher @mobile_num = '01000000001';
IF (SELECT a FROM #one_int) <> 2 THROW 50203, 'Account_Highest_Voucher', 1;

INSERT INTO #payments EXEC Top_Successful_Payments @mobile_num = '01000000001';
IF (SELECT COUNT(*) FROM #payments) <> 2 THROW 50204, 'Top_Successful_Payments', 1;

INSERT INTO #plans EXEC Unsubscribed_Plans @mobile_num = '01000000002';
IF (SELECT COUNT(*) FROM #plans) <> 2 THROW 50205, 'Unsubscribed_Plans', 1;

EXEC Total_Points_Account @mobile_num = '01000000001';
IF (SELECT points FROM customer_account WHERE mobileNo = '01000000001') <> 50 THROW 50206, 'Total_Points_Account', 1;

EXEC Redeem_voucher_points @mobile_num = '01000000001', @voucher_id = 3;
IF (SELECT points FROM customer_account WHERE mobileNo = '01000000001') <> 40
   OR (SELECT mobileNo FROM Voucher WHERE voucherID = 3) <> '01000000001' THROW 50207, 'Redeem_voucher_points', 1;

EXEC Initiate_plan_payment @mobile_num = '01000000001', @amount = 300, @payment_method = 'cash', @plan_id = 2;
IF (SELECT status FROM Subscription WHERE mobileNo = '01000000001' AND planID = 2) <> 'active' THROW 50208, 'Initiate_plan_payment', 1;

EXEC Payment_wallet_cashback @mobile_num = '01000000001', @payment_id = 1, @benefit_id = 1;
IF (SELECT current_balance FROM Wallet WHERE walletID = 1) <> 110 THROW 50209, 'Payment_wallet_cashback', 1;

EXEC Initiate_balance_payment @mobile_num = '01000000002', @amount = 25, @payment_method = 'credit';
IF (SELECT balance FROM customer_account WHERE mobileNo = '01000000002') <> 75 THROW 50210, 'Initiate_balance_payment', 1;

EXEC Benefits_Account @mobile_num = '01000000001', @plan_id = 1;
IF EXISTS (SELECT 1 FROM Benefits WHERE benefitID IN (1, 2) AND mobileNo IS NOT NULL) THROW 50211, 'Benefits_Account', 1;

PRINT 'PASS  12 stored procedures (plus createAllTables)';
GO

PRINT 'All checks passed.';
