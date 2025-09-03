/* 
CTE: informacje dotyczące kontaktu z klientem 
Zmieniono wartości logiczne w kolumnach is_success i previous_outcome, na odpowiadające im tekstowe odpowiedniki (tak jak w oryginalnym zbiorze CSV).
Uwzględniono tylko kontakty telefoniczne i komórkowe.
*/
WITH contact_info AS (
	SELECT
		client_id,
		contact_date, 
		contact_duration,
		CASE
			WHEN is_success IS True THEN 'yes'
			ELSE 'no'
		END AS is_success, 
		channel_of_contact, 
		number_of_contacts,
		COALESCE(days_since_last_contact, 999) AS days_since_last_contact, -- brak wcześniejszego kontaktu
		COALESCE(previous_campaign_contacts, 0) AS previous_campaign_contacts, -- brak kontaktów w poprzednich kampaniach
		CASE
			WHEN previous_outcome IS True THEN 'success'
			WHEN previous_outcome IS False THEN 'failure'
			ELSE 'nonexistent'
		END as previous_outcome,
		year_month
	FROM contacts
	WHERE channel_of_contact IN ('telephone', 'cellular')
),

/* 
CTE: podstawowe informacje o kliencie 
Dane demograficzne klienta. Wartości NULL zastępowane będą później etykietą 'unknown'.
*/
client_info AS (
	SELECT
		client_id,
		date_of_birth,
		job_name,
		marital_status,
		education
	FROM clients
),

/* 
CTE: informacje o produktach przypisanych do klientów 
Używane do ustalenia, czy klient posiada kredyt mieszkaniowy lub pożyczkę osobistą.
*/
client_products_info AS (
	SELECT
		client_id,
		product_id,
		status
	FROM client_products
),

/* 
CTE: informacje o produktach dostępnych w ofercie banku 
Potrzebne do zidentyfikowania typu produktu.
*/
products_info AS (
	SELECT
		product_id,
		product_type
	FROM products
),

/* 
CTE: dane makroekonomiczne (powiązane po kolumnie year_month) 
Używane do określenia wpływu czynników zewnętrznych na decyzje klientów.
*/
macroeconomics_info AS (
	SELECT
		year_month,
		emp_var_rate,
		cons_price_idx,
		cons_conf_idx,
		euribor3m,
		nr_employed
	FROM macroeconomics
),

/* 
CTE: ustalenie, czy klient posiada kredyt mieszkaniowy lub pożyczkę osobistą 
Jeśli klient ma aktywny produkt danego typu -> 'yes', w pozostałych przypadkach -> 'no'.
*/
loan_statuses AS (
	SELECT
		c.client_id,
		-- housing loan
		MAX(CASE 
			WHEN p.product_type = 'housing loan' AND cp.status = 'active' THEN 'yes'
			ELSE 'no'
		END) AS housing_loan,
		-- personal loan
		MAX(CASE 
			WHEN p.product_type = 'personal loan' AND cp.status = 'active' THEN 'yes'
			ELSE 'no'
		END) AS personal_loan
	FROM clients c
	LEFT JOIN client_products cp ON c.client_id = cp.client_id
	LEFT JOIN products p ON cp.product_id = p.product_id
	GROUP BY c.client_id
)

/* 
Finalne zapytanie: zwraca przekształcony zestaw danych zgodny z oryginalnym plikiem CSV.
Wiek klienta wyliczany na podstawie daty kontaktu i daty urodzenia.
Braki w danych uzupełniane etykietą 'unknown'.
*/
SELECT 
	-- informacje o kliencie
	EXTRACT(YEAR FROM AGE(contact_date, date_of_birth)) AS age,
	COALESCE(job_name, 'unknown') AS job_name,
	COALESCE(marital_status, 'unknown') AS marital_status,
	COALESCE(education, 'unknown') AS education,
	
	-- posiadane produkty
	housing_loan,
	personal_loan,
	
	-- informacje o kontakcie
	TO_CHAR(contact_date, 'Day') AS day_name,
	TO_CHAR(contact_date, 'Month') AS month_name,
	contact_duration, 
	is_success, 
	channel_of_contact, 
	number_of_contacts,
	days_since_last_contact
	previous_campaign_contacts,
	previous_outcome,
	
	-- wskaźniki makroekonomiczne
	emp_var_rate,
	cons_price_idx,
	cons_conf_idx,
	euribor3m,
	nr_employed
	
FROM contact_info coi
LEFT JOIN client_info cli ON coi.client_id = cli.client_id
LEFT JOIN macroeconomics_info mi ON coi.year_month = mi.year_month
LEFT JOIN client_products_info cpi ON cpi.client_id = coi.client_id
LEFT JOIN products_info pi ON pi.product_id = cpi.product_id
LEFT JOIN loan_statuses ls ON coi.client_id = ls.client_id
ORDER BY contact_date;
