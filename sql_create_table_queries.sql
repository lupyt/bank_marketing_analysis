-- Tabela przechowująca dane demograficzne klientów
CREATE TABLE clients (
    client_id SERIAL PRIMARY KEY,                             -- Unikalny identyfikator klienta
    first_name VARCHAR(100) NOT NULL,                         -- Imię klienta
    last_name VARCHAR(100) NOT NULL,                          -- Nazwisko klienta
    date_of_birth DATE NOT NULL,                              -- Data urodzenia
    gender CHAR(1),                                           -- Płeć klienta: 'M', 'F' lub NULL
    marital_status VARCHAR(20),                               -- Stan cywilny: np. 'single', 'married'
    education VARCHAR(20),                                    -- Wykształcenie: np. 'primary', 'tertiary'
    job_name VARCHAR(50),                                     -- Zawód klienta
    created_at TIMESTAMP DEFAULT NOW()                        -- Data dodania wpisu do tabeli
);

-- Tabela przechowująca dane o kontaktach z klientami
CREATE TABLE contacts (
    contact_id SERIAL PRIMARY KEY,                            -- Unikalny identyfikator kontaktu
    client_id INT REFERENCES clients(client_id) NOT NULL,     -- Klient, do którego wykonano kontakt
    contact_date DATE NOT NULL,                               -- Data kontaktu
    contact_duration INT CHECK (contact_duration >= 0),       -- Długość rozmowy w sekundach (≥ 0)
    is_success BOOLEAN NOT NULL,                              -- Czy kontakt zakończył się sukcesem
    channel_of_contact VARCHAR(20) NOT NULL                   -- Kanał kontaktu (telefoniczny, komórkowy, email)
        CHECK (channel_of_contact IN ('telephone', 'cellular', 'email')),
    number_of_contacts INT DEFAULT 0,                         -- Liczba kontaktów z klientem w tej kampanii
    days_since_last_contact INT CHECK (days_since_last_contact >= 0),  -- Dni od poprzedniego kontaktu
    previous_campaign_contacts INT CHECK (previous_campaign_contacts >= 0), -- Liczba kontaktów w poprzednich kampaniach
    previous_outcome BOOLEAN,                                 -- Czy poprzedni kontakt zakończył się sukcesem
    year_month INT REFERENCES macroeconomics(year_month)      -- Klucz łączący z tabelą makroekonomiczną (format YYYYMM)
);

-- Tabela przechowująca relacje między klientami a posiadanymi przez nich produktami
CREATE TABLE client_products (
    client_id INT REFERENCES clients(client_id),              -- Klient
    product_id INT REFERENCES products(product_id),           -- Produkt
    status VARCHAR(20),                                       -- Status produktu: np. 'active', 'closed'
    balance NUMERIC NOT NULL CHECK (balance >= 0),            -- Obecne saldo produktu (≥ 0)
    start_date DATE NOT NULL,                                 -- Data rozpoczęcia produktu
    end_date DATE,                                            -- Data zakończenia produktu (jeśli dotyczy)
    created_at TIMESTAMP DEFAULT NOW(),                       -- Data dodania wpisu
    PRIMARY KEY (client_id, product_id)                       -- Klient może mieć tylko jeden wpis dla danego produktu
);

-- Tabela z produktami banku
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,                            -- Unikalny identyfikator produktu
    product_type VARCHAR(50) NOT NULL,                        -- Typ produktu (np. 'personal loan', 'housing loan', '')
    currency CHAR(3) NOT NULL CHECK (currency IN ('EUR', 'PLN', 'USD', 'GBP')), -- Waluta produktu
    description TEXT                                          -- Opcjonalny opis produktu
);

-- Tabela z miesięcznymi wskaźnikami makroekonomicznymi
CREATE TABLE macroeconomics (
    year_month INT PRIMARY KEY,                               -- Klucz: rok i miesiąc w formacie YYYYMM
    emp_var_rate NUMERIC(5,1),                                -- Zmiana zatrudnienia (%)
    cons_price_idx NUMERIC(6,3),                              -- Wskaźnik cen towarów i usług (CPI)
    cons_conf_idx NUMERIC(5,1),                               -- Wskaźnik zaufania konsumentów
    euribor3m NUMERIC(6,3),                                   -- 3-miesięczny wskaźnik EURIBOR
    nr_employed BIGINT CHECK (nr_employed >= 0)               -- Liczba zatrudnionych (≥ 0)
);
