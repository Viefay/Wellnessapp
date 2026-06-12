### overview

Tujuan : Deteksi gait event (Heel strike dan Toe off)

Deteksi untuk prediksi event gait (Left, Right) anotasi
- Toe Off (LF, RF)
- Heel Strike (LF, RF)

Algoritma yang digunakan : Bitcn-Bigru-CrossAttention

Notes  : plot.png tampilan grafik untuk prediksi gait events

detection_left_right_gait_events.ipynb

Requirements Dataset 
- Healthy/HS 
- Neuro/CIPN
- Neuro/CVA
- Neuro/PD
- Neuro/RIL

Contoh Output :

"leftGaitEvents": [396, 443], [526, 568], [651, 696], [783, 826], [909, 951], [1035, 1081], [1165, 1209], [1293, 1334], [1416, 1461], [1545, 1588], [1669, 1690], [1785, 1831], [1919, 1963], [2049, 2091], [2173, 2217], [2300, 2344], [2429, 2474], [2564, 2608], [2696, 2738], [2829, 2869], [2958, 3002], [3090, 3127], [3216, 3246]

"rightGaitEvents": [396, 443], [526, 568], [651, 696], [783, 826], [909, 951], [1035, 1081], [1165, 1209], [1293, 1334], [1416, 1461], [1545, 1588], [1669, 1690], [1785, 1831], [1919, 1963], [2049, 2091], [2173, 2217], [2300, 2344], [2429, 2474], [2564, 2608], [2696, 2738], [2829, 2869], [2958, 3002], [3090, 3127], [3216, 3246]

dataset : 
datasetnya bisa pake penyakit lain (Requirements Dataset), pake meta data: height, weight, bmi, subject 

Sensor Gyroscope + Accelerometer 

trial error:
1. CVA HS data sensor: 
    - Sensor (LF-RF)
    - Sensor LB-LF-RF
2. HS-CVA-PD: 
    - Sensor (LF-RF)
    - Sensor LB-LF-RF
3. HS-CVA-CIPN: 
    - Sensor (LF-RF)
    - Sensor LB-LF-RF
4. HS-CVA-RIL: 
    - Sensor (LF-RF)
    - Sensor LB-LF-RF