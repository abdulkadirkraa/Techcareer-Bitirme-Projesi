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
('ar-XA','Arap�a'),
('de','Almanca'),
('es','�spayolca'),
('fr','Frans�zca'),
('ja','Japonca'),
('ru','Rus�a'),
('zh- bira','�ince (Geleneksel)'),
('en','�ngilizce'),
('tr','T�rk�e'),
('it','�talyanca');

EXEC sp_RehberOlustur 'Ay�e','Y�lmaz','Kad�n','5551234567','�ngilizce','Japonca','�talyanca','Rus�a'
EXEC sp_RehberOlustur 'Ali','Demir','Erkek','5551234568','Frans�zca','�spayolca'
EXEC sp_RehberOlustur 'Esra','Kaya','Kad�n','5551234569','�ngilizce','�ince (Geleneksel)'
EXEC sp_RehberOlustur 'Deniz','�zkan','Belirsiz','5551234579','Arap�a','Almanca','�spayolca','Japonca'
EXEC sp_RehberOlustur 'Mehmet','�zt�rk','Erkek','5551234571','�ngilizce','�talyanca'
EXEC sp_RehberOlustur 'G�ne�','Solmaz','Kad�n','5551234572','Rus�a','�ince (Geleneksel)','Japonca'

EXEC sp_RehbereDilEkleme 'Ay�e','Y�lmaz','Frans�zca'
EXEC sp_RehbereDilEkleme 'Ali','Demir','Rus�a'

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
('Dolmabah�e Saray�',90),
('Galata Kulesi',60),
('�stanbul Bo�az�',50),
('K�z Kulesi',60),
('Kapal� �ar��',40),
('Emin�n�',45),
('Topkap� Saray� M�zesi',55),
('Yerebatan Sarn�c�',65),
('Sultan Ahmet Cami',30),
('Sultan Ahmet Meydan�',35),
('M�s�r �ar��s�',80),
('Taksim Meydan�',20),
('�stiklal Caddesi',45),
('Aya �rini M�zesi',55),
('G�lhane Park�',25),
('Y�ld�z Saray�',25),
('Pierre Loti Tepesi',70),
('Balat',50),
('Rumeli Hisar�',20)

EXEC sp_TurOlustur 'A','Ayasofya Cami','Dolmabah�e Saray�','Galata Kulesi'
EXEC sp_TurOlustur 'B','�stanbul Bo�az�','K�z Kulesi'
EXEC sp_TurOlustur 'C','Kapal� �ar��'
EXEC sp_TurOlustur 'D','Emin�n�','Topkap� Saray� M�zesi','Sultan Ahmet Cami'
EXEC sp_TurOlustur 'E','Sultan Ahmet Meydan�','M�s�r �ar��s�'
EXEC sp_TurOlustur 'F','Taksim Meydan�'
EXEC sp_TurOlustur 'G','�stiklal Caddesi','Ayasofya Cami','Dolmabah�e Saray�'
EXEC sp_TurOlustur 'H','Aya �rini M�zesi','Galata Kulesi'
EXEC sp_TurOlustur 'I','G�lhane Park�'
EXEC sp_TurOlustur 'J','Rumeli Hisar�'

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

EXEC sp_DetayliTurTanimla 'A','2023-06-10 08:45','Ay�e','Y�lmaz'
EXEC sp_DetayliTurTanimla 'B','2023-06-11 09:00','Ay�e','Y�lmaz'
EXEC sp_DetayliTurTanimla 'C','2023-06-10 09:15','Ali','Demir'
EXEC sp_DetayliTurTanimla 'D','2023-06-11 09:30','Ali','Demir'
EXEC sp_DetayliTurTanimla 'A','2023-06-10 08:45','Esra','Kaya'
EXEC sp_DetayliTurTanimla 'A','2023-06-11 09:00','Mehmet','�zt�rk'
EXEC sp_DetayliTurTanimla 'B','2023-06-11 09:00','G�ne�','Solmaz'
EXEC sp_DetayliTurTanimla 'B','2023-06-12 09:15','Ali','Demir'
EXEC sp_DetayliTurTanimla 'C','2023-06-10 09:30','Mehmet','�zt�rk'
EXEC sp_DetayliTurTanimla 'D','2023-06-12 09:45','Esra','Kaya'

EXEC sp_DetayliTurGuncelle 'B','2023-06-12 09:15','Ali','Demir','2023-06-12 09:16','G�ne�','Solmaz'
EXEC sp_DetayliTurGuncelle @turisim='C',@turtarihi='2023-06-10 09:30',@rehberisim='Mehmet',@rehbersoyisim='�zt�rk',@yenirehberisim='G�ne�',@yenirehbersoyisim='Solmaz'
EXEC sp_DetayliTurGuncelle @turisim='D',@turtarihi='2023-06-12 09:45',@rehberisim='Esra',@rehbersoyisim='Kaya',@yenirehberisim='Mehmet',@yenirehbersoyisim='�zt�rk'
EXEC sp_DetayliTurGuncelle @turisim='D',@turtarihi='2023-06-12 09:45',@rehberisim='Mehmet',@rehbersoyisim='�zt�rk',@yeniturtarihi='2023-06-12 09:46'

EXEC sp_DetayliTurSatisaAc 'A','2023-06-10 08:45','Ay�e','Y�lmaz'
EXEC sp_DetayliTurSatisaAc 'D','2023-06-11 09:30','Mehmet','�zt�rk'
EXEC sp_DetayliTurSatisaAc 'A','2023-06-10 08:45','Esra','Kaya'

EXEC sp_DetayliTurIptal 'D','2023-06-11 09:30','Mehmet','�zt�rk'

EXEC sp_TurSatinAlma 'Ali','Bayram','1910-08-12','Alman','Polonya','A','2023-06-10 08:45','Esra','Kaya'
EXEC sp_TurSatinAlma 'Gon','Freecs','1990-09-09','Japon','Japonya','A','2023-06-10 08:45','Esra','Kaya'
EXEC sp_TurSatinAlma 'Angela','Merkel','1930-03-28','Frans�z','�svi�re','A','2023-06-10 08:45','Ay�e','Y�lmaz'

SELECT * FROM dbo.FaturaDetayGoster('FTR20230504001')

SELECT * FROM dbo.TumFaturalariGoster()

EXEC sp_TuraBolgeEkleme 'B','Ayasofya Cami','Dolmabah�e Saray�'
EXEC sp_TuraBolgeEkleme 'C','Ayasofya Cami','Dolmabah�e Saray�'
EXEC sp_TuraBolgeEkleme 'A','Ayasofya Cami','Dolmabah�e Saray�'

EXEC sp_TurdanBolgeSilme 'A','Ayasofya Cami'
EXEC sp_TurdanBolgeSilme 'C','Dolmabah�e Saray�'
EXEC sp_TurdanBolgeSilme 'I','G�lhane Park�'

EXEC sp_TurunBolgesiDegistir 'G','Ayasofya Cami','Galata Kulesi'
EXEC sp_TurunBolgesiDegistir 'A','Galata Kulesi','K�z Kulesi'

SELECT * FROM dbo.RehberleriGoruntule()

SELECT * FROM dbo.TurlariGoruntule()

SELECT * FROM dbo.DetayliTurGoruntuleme()
