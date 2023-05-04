CREATE DATABASE TurSirketi

CREATE TABLE Dil(
	dil_kodu NVARCHAR(10) PRIMARY KEY,
	isim NVARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Rehber(
	id INT IDENTITY PRIMARY KEY,
	isim NVARCHAR(20) NOT NULL,
	soyisim NVARCHAR(40) NOT NULL,
	cinsiyet NVARCHAR(10),
	telefon NVARCHAR(10) NOT NULL
);

CREATE TABLE [Rehber Dilleri](
	rehber_id INT,
	dil_kodu NVARCHAR(10),
	FOREIGN KEY (rehber_id) REFERENCES Rehber(id) ON UPDATE CASCADE,
	FOREIGN KEY (dil_kodu) REFERENCES Dil(dil_kodu) ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO Dil(dil_kodu,isim) VALUES
('ar-XA','Arapça'),
('de','Almanca'),
('es','Ýspayolca'),
('fr','Fransýzca'),
('ja','Japonca'),
('ru','Rusça'),
('zh- bira','Çince (Geleneksel)'),
('en','Ýngilizce'),
('tr','Türkçe'),
('it','Ýtalyanca');

EXEC sp_RehberOlustur 'Ayþe','Yýlmaz','Kadýn','5551234567','Ýngilizce','Japonca','Ýtalyanca','Rusça'
EXEC sp_RehberOlustur 'Ali','Demir','Erkek','5551234568','Fransýzca','Ýspayolca'
EXEC sp_RehberOlustur 'Esra','Kaya','Kadýn','5551234569','Ýngilizce','Çince (Geleneksel)'
EXEC sp_RehberOlustur 'Deniz','Özkan','Belirsiz','5551234579','Arapça','Almanca','Ýspayolca','Japonca'
EXEC sp_RehberOlustur 'Mehmet','Öztürk','Erkek','5551234571','Ýngilizce','Ýtalyanca'
EXEC sp_RehberOlustur 'Güneþ','Solmaz','Kadýn','5551234572','Rusça','Çince (Geleneksel)','Japonca'

EXEC sp_RehbereDilEkleme 'Ayþe','Yýlmaz','Fransýzca'
EXEC sp_RehbereDilEkleme 'Ali','Demir','Rusça'

CREATE TABLE Bolge(
	id INT IDENTITY PRIMARY KEY,
	isim NVARCHAR(30) NOT NULL UNIQUE,
	hizmet_ucreti INT NOT NULL CHECK(hizmet_ucreti>=20)
);

CREATE TABLE Tur(
	id INT IDENTITY PRIMARY KEY,
	isim NVARCHAR(150) NOT NULL UNIQUE,
	ucret INT NOT NULL
);

CREATE TABLE [Tur Bolge](
	tur_id INT NOT NULL,
	bolge_id INT NOT NULL,
	FOREIGN KEY(tur_id) REFERENCES Tur(id) ON DELETE CASCADE,
	FOREIGN KEY(bolge_id) REFERENCES Bolge(id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Bolge VALUES
('Ayasofya Cami',50),
('Dolmabahçe Sarayý',90),
('Galata Kulesi',60),
('Ýstanbul Boðazý',50),
('Kýz Kulesi',60),
('Kapalý Çarþý',40),
('Eminönü',45),
('Topkapý Sarayý Müzesi',55),
('Yerebatan Sarnýcý',65),
('Sultan Ahmet Cami',30),
('Sultan Ahmet Meydaný',35),
('Mýsýr Çarþýsý',80),
('Taksim Meydaný',20),
('Ýstiklal Caddesi',45),
('Aya Ýrini Müzesi',55),
('Gülhane Parký',25),
('Yýldýz Sarayý',25),
('Pierre Loti Tepesi',70),
('Balat',50),
('Rumeli Hisarý',20)

EXEC sp_TurOlustur 'A','Ayasofya Cami','Dolmabahçe Sarayý','Galata Kulesi'
EXEC sp_TurOlustur 'B','Ýstanbul Boðazý','Kýz Kulesi'
EXEC sp_TurOlustur 'C','Kapalý Çarþý'
EXEC sp_TurOlustur 'D','Eminönü','Topkapý Sarayý Müzesi','Sultan Ahmet Cami'
EXEC sp_TurOlustur 'E','Sultan Ahmet Meydaný','Mýsýr Çarþýsý'
EXEC sp_TurOlustur 'F','Taksim Meydaný'
EXEC sp_TurOlustur 'G','Ýstiklal Caddesi','Ayasofya Cami','Dolmabahçe Sarayý'
EXEC sp_TurOlustur 'H','Aya Ýrini Müzesi','Galata Kulesi'
EXEC sp_TurOlustur 'I','Gülhane Parký'
EXEC sp_TurOlustur 'J','Rumeli Hisarý'

CREATE TABLE [Tur Detay](
	id INT IDENTITY PRIMARY KEY,
	tur_id INT NOT NULL,
	rehber_id INT NOT NULL,
	tur_tarihi SMALLDATETIME NOT NULL CHECK (tur_tarihi >= DATEADD(day, 7, GETDATE())),
	satis_durumu BIT NOT NULL
	FOREIGN KEY(tur_id) REFERENCES Tur(id) ON UPDATE CASCADE,
	FOREIGN KEY(rehber_id) REFERENCES Rehber(id) ON UPDATE CASCADE
);
CREATE TABLE Turist(
	id INT IDENTITY PRIMARY KEY,
	isim NVARCHAR(20) NOT NULL,
	soyisim NVARCHAR(40) NOT NULL,
	dogum_tarihi DATE NOT NULL,
	uyruk NVARCHAR(50),
	geldigi_ulke NVARCHAR(50)
);
CREATE TABLE fatura_seq_table
(
  id INT PRIMARY KEY identity,
  sayac INT NULL
);
CREATE TABLE Fatura(
	faturaNo NVARCHAR(14) NOT NULL,
	detay_id INT NOT NULL  FOREIGN KEY REFERENCES [Tur Detay](id),
	turist_id INT NOT NULL  FOREIGN KEY REFERENCES Turist(id),
	kesilme_tarihi SMALLDATETIME NOT NULL,
	tutar INT NOT NULL
);

EXEC sp_DetayliTurTanimla 'A','2023-06-10 08:45','Ayþe','Yýlmaz'
EXEC sp_DetayliTurTanimla 'B','2023-06-11 09:00','Ayþe','Yýlmaz'
EXEC sp_DetayliTurTanimla 'C','2023-06-10 09:15','Ali','Demir'
EXEC sp_DetayliTurTanimla 'D','2023-06-11 09:30','Ali','Demir'
EXEC sp_DetayliTurTanimla 'A','2023-06-10 08:45','Esra','Kaya'
EXEC sp_DetayliTurTanimla 'A','2023-06-11 09:00','Mehmet','Öztürk'
EXEC sp_DetayliTurTanimla 'B','2023-06-11 09:00','Güneþ','Solmaz'
EXEC sp_DetayliTurTanimla 'B','2023-06-12 09:15','Ali','Demir'
EXEC sp_DetayliTurTanimla 'C','2023-06-10 09:30','Mehmet','Öztürk'
EXEC sp_DetayliTurTanimla 'D','2023-06-12 09:45','Esra','Kaya'

EXEC sp_DetayliTurGuncelle 'B','2023-06-12 09:15','Ali','Demir','2023-06-12 09:16','Güneþ','Solmaz'
EXEC sp_DetayliTurGuncelle @turisim='C',@turtarihi='2023-06-10 09:30',@rehberisim='Mehmet',@rehbersoyisim='Öztürk',@yenirehberisim='Güneþ',@yenirehbersoyisim='Solmaz'
EXEC sp_DetayliTurGuncelle @turisim='D',@turtarihi='2023-06-12 09:45',@rehberisim='Esra',@rehbersoyisim='Kaya',@yenirehberisim='Mehmet',@yenirehbersoyisim='Öztürk'
EXEC sp_DetayliTurGuncelle @turisim='D',@turtarihi='2023-06-12 09:45',@rehberisim='Mehmet',@rehbersoyisim='Öztürk',@yeniturtarihi='2023-06-12 09:46'

EXEC sp_DetayliTurSatisaAc 'A','2023-06-10 08:45','Ayþe','Yýlmaz'
EXEC sp_DetayliTurSatisaAc 'D','2023-06-11 09:30','Mehmet','Öztürk'
EXEC sp_DetayliTurSatisaAc 'A','2023-06-10 08:45','Esra','Kaya'

EXEC sp_DetayliTurIptal 'D','2023-06-11 09:30','Mehmet','Öztürk'

EXEC sp_TurSatinAlma 'Ali','Bayram','1910-08-12','Alman','Polonya','A','2023-06-10 08:45','Esra','Kaya'
EXEC sp_TurSatinAlma 'Gon','Freecs','1990-09-09','Japon','Japonya','A','2023-06-10 08:45','Esra','Kaya'
EXEC sp_TurSatinAlma 'Angela','Merkel','1930-03-28','Fransýz','Ýsviçre','A','2023-06-10 08:45','Ayþe','Yýlmaz'

SELECT * FROM dbo.FaturaDetayGoster('FTR20230504001')

SELECT * FROM dbo.TumFaturalariGoster()

EXEC sp_TuraBolgeEkleme 'B','Ayasofya Cami','Dolmabahçe Sarayý'
EXEC sp_TuraBolgeEkleme 'C','Ayasofya Cami','Dolmabahçe Sarayý'
EXEC sp_TuraBolgeEkleme 'A','Ayasofya Cami','Dolmabahçe Sarayý'

EXEC sp_TurdanBolgeSilme 'A','Ayasofya Cami'
EXEC sp_TurdanBolgeSilme 'C','Dolmabahçe Sarayý'
EXEC sp_TurdanBolgeSilme 'I','Gülhane Parký'

EXEC sp_TurunBolgesiDegistir 'G','Ayasofya Cami','Galata Kulesi'
EXEC sp_TurunBolgesiDegistir 'A','Galata Kulesi','Kýz Kulesi'

SELECT * FROM dbo.RehberleriGoruntule()

SELECT * FROM dbo.TurlariGoruntule()

SELECT * FROM dbo.DetayliTurGoruntuleme()
