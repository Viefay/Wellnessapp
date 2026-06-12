### overview

Tujuan : Aplikasi Wellness App 

(1) bisa prediksi keparahan (FMA-LE)
(2) prediksi gait events (Anotasi Toe off vs Heel Strike)
(3) semiogram (20 Paramater) --> Backend

Hosting: Flutter

Metode pengukuran di HP: Taro HP ganti2an di kaki kanan dan kiri

TO DO:
1. bikin auto preprocessing sinyal sensor -> Free_Acc : 
2. algoritma semiogram (20 parameter)
3. convert model ke .tflite 
4. Struktur halaman
    - Home: penjelasan tes
    - Recording Page: tombol start/stop, timer
    - Processing (backend): Perhitungan Semiogram dan perhitungan FreeAcc 
    - Result: tampilkan prediksi FMA-LE (Semiogram, Keparahan FMA-LE, CVA vs HS) 

5. Hosting flutter

What i want : (i file [Wellness_app](Wellness_app))
1. Frontend App = 
    - Input Time series (Gyr dan Acc) = Record ke aplikasinya 
    - Integrate Model ke dalam UI nya  
2. Backend
    - Perhitungan Semiogram (Backend)
    | Criteria        | Parameter    |
    |----------------|---------------|
    | Average speed  | V (m/s)       |
    | Springiness    | StrT (s)      |
    |                | UtrT (s)      |
    | Smoothness     | LDLJₐ (-)     |
    |                | SPARCᵣₒₜ (-)   |
    | Steadiness     | CVStrT (%)    |
    |                | CVdstT (%)    |
    |                | P1ₐcc (-)     |
    |                | P2ₐcc (-)     |
    | Sturdiness     | SteL (m)      |
    | Stability      | RMSₐML (m/s²) |
    | Symmetry       | iHRₐAP (%)    |
    |                | iHRₐCC (%)    |
    |                | iHRₐML (%)    |
    |                | P1P2ₐcc (-)   |
    |                | swTᵣ (-)      |
    | Synchronization| dstT (%)      |
    - Masuk database 
    - Validasi input time series yang masuk dengan rumus : 
        Freeacc = Acc(Total) - Gravitasi 



