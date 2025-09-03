# Analiza Marketingowa Banku
## Celem projektu była analiza kampanii marketingowych banku, identyfikacja czynników wpływających na decyzję o założeniu lokaty terminowej oraz opracowanie rekomendacji dotyczących bardziej efektywnego targetowania i planowania kontaktów w przyszłych kampaniach.

Portugalski bank prowadził intensywne kampanie telemarketingowe w latach 2008-2010, w okresie silnych wahań gospodarczych związanych z globalnym kryzysem finansowym. 

Analiza koncentrowała się na trzech kluczowych obszarach:
1. Profil klienta - które grupy demografgiczne i zawodowe najczęściej zakładały lokaty.
2. Efektywność kontaktów - jak zmieniała się skuteczność w zależności od liczby rozmów i wcześniejszych kampanii.
3. Czynniki makroekonomiczne - ocena wpływu czynników makroekonomicznych na skuteczność kampanii.

### Zakres działań obejmował:
1. Zaprojektowanie bazy danych (SQL)
    - Stworzono propozycję struktury relacyjnej bazy danych.
    - Przygotowano skrypt tworzący zaproponowaną bazę danych. 
    - Stworzono zapytania pozwalające odtworzyć oryginalne kolumny z pliku CSV. 
2. Analiza i raport
    - Przeprowadzono eksploracyjną analizę danych, koncentrującą się na skuteczności kontaktów, profilach klientów i otoczeniu makroekonomicznym.
    - Zastosowano miary statystyczne i współczynniki determinacji (R²), aby wskazać zależności między zmiennymi.
    - Stworzono raport zawierający:
        - przegląd projektu i jego celów
        - podsumowanie wniosków z analizy
        - rekomendacje strategiczne
3. Dashboard w Excelu
    - Przekształcono dane do potrzeb wizualizacji.
    - Zaprojektowano dashboard przedstawiający kluczowe wnioski: profile klientów, efektywność kontaktów i wpływ czynników zewnętrznych.

## Struktura zbioru danych
Dane źródłowe dostępne były w formacie CSV i zawierały gotowe kolumny. Na ich podstawie opracowano propozycję relacyjnej bazy danych SQL, która mogłaby służyć do pozyskania analogicznych danych.

Repozytorium zawiera:
- Zapytania CREATE TABLE tworzące strukturę bazy danych. (sql_create_table_queries.sql)
- Zapytania SELECT pozwalające odtworzyć zbiór danych w układzie zgodnym z plikiem CSV. (sql_select_queries.sql)

Na diagramie przedstawiono graficzną reprezentację proponawanej bazy danych:
- Kolumny oznaczone \*\*nazwa_kolumny\*\* odpowiadają polom obecnym w pliku CSV lub bezpośrednio z niego wyliczalnym (np. age z date_of_birth, day i month z contact_date).
- Pozostałe kolumny to dane uzupełniające.

Zbiór danych obejmował 5 tabel:
- clients - informacje o klientach
- contacts - dane o kontaktach, ich przebiegu oraz wcześniejszych interakcjach
- client_products - powiązanie klientów z produktami oraz statusem posiadanych produktów
- products - katalog produktów bankowych
- macroeconomic - dostępne wskaźniki makroekonomiczne

<img width="1289" height="613" alt="bank_marketing_dataset_structure" src="https://github.com/user-attachments/assets/f16a405e-92de-4e30-a316-cf485170a3da" />

## Podsumowanie wniosków
Kluczowym miernikiem skuteczności był odsetek kontaktów zakończonych otwarciem lokaty.

**Profil klienta**
- Najwyższą skuteczność kampanii odnotowano wśród osób w wieku 18–24 lata (24%) oraz 65+ (47%).
- Z grup zawodowych najchętniej zakładali lokaty studenci (31,5%) i emeryci (25%), choć liczba kontaktów w obu grupach była stosunkowo niewielka w porównaniu do innych (<2000), co zwiększa podatność wyników na wahania.
- W zawodach z większą próbą (powyżej 2000 kontaktów) najwyższą skuteczność miały osoby zatrudnione w administracji (13%), a najniższą pracownicy fizyczni (6,9%).
- Wysoki wynik grupy 18-24 był napędzany głównie przez studentów, a w przypadku emerytów przez osoby 65+.
- Single zakładali lokaty ok. 37% częściej niż osoby zamężne lub rozwiedzione.
- Skłonność do zakładania lokat rosła wraz z poziomem wykształcenia: 8,7% (podstawowe), 11% (średnie) i 13,7% (wyższe).
- Obecność kredytu hipotecznego lub konsumpcyjnego nie miała istotnego wpływu na skuteczność.

**Efektywność kontaktów**
- Klienci, którzy otworzyli lokatę podczas wcześniejszej kampanii, robili to ponownie w 65% przypadków. Wśród klientów, którzy odmówili, wskaźnik wynosił 14%, a w grupie bez wcześniejszego kontaktu 8,8%.
- W ramach bieżącej kampanii skuteczność malała z każdym kolejnym połączeniem: od 13% przy pierwszym kontakcie do poniżej 5% przy dziesiątym. Zależność była silnie liniowa (R² = 0,92).
- W dłuższej perspektywie skuteczność rosła wraz z liczbą kontaktów we wcześniejszych kampaniach (R² = 0,90, trend logarytmiczny): 9% przy braku historii kontaktu, 21% po jednej kampanii, 46% po dwóch i 59% po trzech.
- Najlepsze rezultaty osiągano w dniach wtorek–czwartek (ok. 12%), nieco słabsze w poniedziałki (10%) i piątki (11%).
- Liczba dni od ostatniego kontaktu nie miała wpływu na skuteczność (R² = 0,02).
  
**Wskaźniki makroekonomiczne**
- Liczba zatrudnionych spadła w trakcie kampanii o ok. 250 tys., jednak skuteczność działań rosła.
- W okresie najwyższego poziomu EURIBOR 3M (~5%) skuteczność była najniższa, natomiast przy najniższym poziomie (~1%) - najwyższa.
- Mimo spadku wskaźnika zaufania konsumentów (z -40 do -50 w II kw. 2008 - I kw. 2009 oraz z -30 do -50 w III kw. 2009 - IV kw. 2010), skuteczność kampanii wzrastała.
- Czynniki ekonomiczne miały ograniczone znaczenie - wzrost skuteczności następował nawet w niesprzyjających warunkach. Kluczowe okazały się historia kontaktów i profil klienta.
- Nie oznacza to braku wpływu otoczenia gospodarczego - w korzystniejszych warunkach skuteczność kampanii mogłaby być jeszcze wyższa.

## Rekomendacje
- Dobierać klientów według profilu - większy priorytet dla singli, osób z wyższym wykształceniem oraz zawodów o ponadprzeciętnej skuteczności (administracja, kadra zarządzająca).
- Rozszerzyć próby w niedoreprezentowanych grupach - studenci i emeryci wykazali wysoką skuteczność, choć ich udział w danych był niski (18–24 lata: 2,6% vs. 9,8% w populacji; 65+: 1,6% vs. 22,1%). Warto zwiększyć próby i zweryfikować potencjał tych grup.
- Traktować studentów jako grupę perspektywiczną - osoby w tym wieku zazwyczaj zakładają lokaty na mniejsze kwoty, ale ich wysoki wskaźnik skuteczności i potencjał dochodowy w przyszłości czynią tę grupę atrakcyjną z perspektywy długoterminowej relacji z bankiem. Zwłaszcza że 65% klientów, którzy raz założyli lokatę, robi to ponownie.
- Ograniczać nadmierną liczbę prób w krótkim czasie - skuteczność maleje wraz z kolejnymi połączeniami w tej samej kampanii.
- Przeprowadzić kalkulację ROI - skuteczność spada liniowo z każdym telefonem w trakcie jednej kampanii. Oszacować, po ilu kontaktach koszt dodatkowych prób przewyższa potencjalny zysk z lokaty.
- Skupić działania na klientach z historią wcześniejszych kontaktów - każda kolejna kampania zwiększała szansę na sprzedaż, zwłaszcza wśród osób, które już wcześniej założyły lokatę.
- Nie opierać decyzji nadmiernie na wskaźnikach makroekonomicznych - wyniki pokazały, że skuteczność zależy zdecydowanie mocniej od profilu klienta oraz zarządzaniu relacją z nim. 

## Dashboard
Poniżej przedstawiono dashboard w Excelu z kluczowymi wykresami i danymi wspierającymi interpretację wyników analizy.

<img width="2154" height="1428" alt="bank_marketing_dashboard2" src="https://github.com/user-attachments/assets/0f5fcb3a-60c0-447d-a75a-692a0f805722" />

## Źródło danych
[Moro et al., 2014] S. Moro, P. Cortez and P. Rita. A Data-Driven Approach to Predict the Success of Bank Telemarketing. Decision Support Systems, In press, http://dx.doi.org/10.1016/j.dss.2014.03.001

  Available at: 
  
  [pdf] http://dx.doi.org/10.1016/j.dss.2014.03.001
                
  [bib] http://www3.dsi.uminho.pt/pcortez/bib/2014-dss.txt
