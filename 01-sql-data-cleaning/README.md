# 🧹 SQL Data Cleaning Project — Tech Layoffs Dataset

Project ini berfokus pada pembersihan dataset `layoffs` menggunakan SQL.  
Tujuannya adalah meningkatkan kualitas data sebelum digunakan untuk analisis lebih lanjut.

## 🎯 Tujuan

- Menghapus data duplikat secara aman
- Menstandarisasi nilai teks (company, industry, country)
- Mengonversi tipe data (DATE, INT, FLOAT)
- Menangani NULL dan blank values
- Menghapus baris yang tidak bisa dipopulasikan nilainya

## 🛠 Tools & Teknologi

- MySQL / SQL
- Window Functions (`ROW_NUMBER()`)
- CTE (`WITH` clause)
- String functions (`TRIM`, `LIKE`)
- Date functions (`STR_TO_DATE`)

## 🧾 Langkah Pembersihan Data

1. **Membuat tabel staging** untuk menjaga data mentah tetap aman.
2. **Mendeteksi duplikat** menggunakan `ROW_NUMBER()` dengan kombinasi beberapa kolom.
3. **Menghapus baris duplikat** dari tabel staging kedua.
4. **Menstandarisasi teks**:
   - Trim spasi di `company`
   - Menyatukan kategori industry `Crypto`
   - Membersihkan nama negara `United States.` → `United States`
5. **Konversi tipe data**:
   - `date` → `DATE`
   - `total_laid_off` → `INT`
   - `percentage_laid_off`, `funds_raised_millions` → `FLOAT`
6. **Menangani NULL dan nilai 'NULL'**:
   - Mengubah string `'NULL'` menjadi `NULL`
   - Mengisi `industry` yang kosong menggunakan self join berdasarkan `company`
7. **Menghapus baris yang tidak berguna**:
   - Jika `total_laid_off` dan `percentage_laid_off` keduanya NULL → baris dihapus.

## 📌 File

- `data_cleaning_project.sql` — berisi seluruh query cleaning step-by-step.

## 💡 Hasil

Setelah proses cleaning:
- Data bebas duplikat
- Kolom teks dan tanggal rapi dan konsisten
- Tipe data lebih tepat sehingga siap untuk analisis lebih lanjut (agregasi, tren, dsb.)

