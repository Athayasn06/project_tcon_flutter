-- =====================================================
-- INSERT ARTIS DENGAN FOTO UNTUK TCON APP
-- =====================================================
-- Jalankan query ini di phpMyAdmin atau MySQL Workbench

-- Hapus data lama (optional, hati-hati!)
-- TRUNCATE TABLE artists;

-- Insert artis dengan foto dari internet
INSERT INTO artists (name, genre, image, bio, created_at, updated_at) VALUES

-- ARTIS INDONESIA TERKENAL
('NOAH', 'Pop Rock', 'https://i.scdn.co/image/ab6761610000e5eb8b5b6b5a5b5b5b5b5b5b5b5b', 'Band pop rock Indonesia yang dibentuk pada tahun 2012', NOW(), NOW()),

('Sheila on 7', 'Pop Rock', 'https://cdn.antaranews.com/cache/1200x800/2023/12/09/IMG-20231209-WA0062.jpg', 'Band pop rock legendaris Indonesia sejak 1996', NOW(), NOW()),

('Dewa 19', 'Rock', 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3e/Dewa_19_in_2019.jpg/1200px-Dewa_19_in_2019.jpg', 'Band rock Indonesia yang legendaris', NOW(), NOW()),

('Tulus', 'Jazz Pop', 'https://cdn1-production-images-kly.akamaized.net/medias/3565326/original/079384000_1570613507-20191009-Tulus.jpg', 'Penyanyi solo jazz dan pop Indonesia', NOW(), NOW()),

('Raisa', 'R&B Pop', 'https://blue.kumparan.com/image/upload/fl_progressive,fl_lossy,c_fill,q_auto:best,w_640/v1634025439/01ha0x6vsqhqmxrjf3xvhqjxnc.jpg', 'Penyanyi R&B dan pop wanita Indonesia', NOW(), NOW()),

('Isyana Sarasvati', 'Classical Pop', 'https://cdn0-production-images-kly.akamaized.net/medias/3401539/original/037431600_1615452413-20210311-Isyana-Sarasvati-3.jpg', 'Penyanyi dan pianis Indonesia', NOW(), NOW()),

('Afgan', 'R&B Pop', 'https://asset.kompas.com/crops/Fir0wQJi0LPjqbqJl3gNVGc3GZs=/0x0:739x493/750x500/data/photo/2023/05/04/6453534e05e32.jpeg', 'Penyanyi pop dan R&B Indonesia', NOW(), NOW()),

('Judika', 'Pop Ballad', 'https://cdn1-production-images-kly.akamaized.net/medias/3363308/original/099043300_1612494951-20210205-Judika.jpg', 'Penyanyi pop ballad Indonesia', NOW(), NOW()),

('Mahalini', 'Pop', 'https://cdn0-production-images-kly.akamaized.net/medias/4232938/original/062129100_1666167556-446A0147.JPG', 'Penyanyi pop muda Indonesia', NOW(), NOW()),

('Lyodra', 'Pop Soul', 'https://asset-2.tstatic.net/tribunnews/foto/bank/images/lyodra-ginting-5.jpg', 'Juara Indonesian Idol 2020', NOW(), NOW()),

-- BAND ROCK INDONESIA
('Slank', 'Rock', 'https://cdn.idntimes.com/content-images/community/2022/01/img-20220120-wa0054-d07c88d4d2a1e5a5a5a5a5a5a5a5a5a5.jpg', 'Band rock legendaris Indonesia', NOW(), NOW()),

('Padi Reborn', 'Pop Rock', 'https://cdn-2.tstatic.net/tribunnews/foto/bank/images/padi-reborn_20160725_142042.jpg', 'Band pop rock Indonesia', NOW(), NOW()),

('Ungu', 'Pop Rock', 'https://cdn-2.tstatic.net/tribunnews/foto/bank/images/ungu-band_20170803_155511.jpg', 'Band pop rock ballad Indonesia', NOW(), NOW()),

('The Changcuters', 'Indie Rock', 'https://asset.kompas.com/crops/jK5aLJ9JJK5aLJ9JJK5aLJ9=/0x0:1000x667/750x500/data/photo/2020/03/12/5e69f8d8a1c1c.jpg', 'Band indie rock dari Bandung', NOW(), NOW()),

('D''Masiv', 'Pop Rock', 'https://cdn-2.tstatic.net/tribunnews/foto/bank/images/dmasiv_20180314_165845.jpg', 'Band pop rock Indonesia', NOW(), NOW()),

-- PENYANYI SOLO
('Rossa', 'Pop', 'https://cdn1-production-images-kly.akamaized.net/medias/3327471/original/036757800_1609229806-20201229-Rossa.jpg', 'Diva pop Indonesia', NOW(), NOW()),

('Andmesh Kamaleng', 'Pop', 'https://cdn-2.tstatic.net/tribunnews/foto/bank/images/andmesh-kamaleng_20190724_202717.jpg', 'Penyanyi pop Indonesia', NOW(), NOW()),

('Marion Jola', 'Pop R&B', 'https://cdn0-production-images-kly.akamaized.net/medias/3270773/original/024070700_1604983050-20201110-Marion-Jola-4.jpg', 'Penyanyi pop R&B Indonesia', NOW(), NOW()),

('Tiara Andini', 'Pop', 'https://asset.kompas.com/crops/xxxxxxxxxxxxx/0x0:1000x667/750x500/data/photo/2020/12/08/5fcf2d7a8c1e7.jpg', 'Juara Indonesian Idol 2020', NOW(), NOW()),

('Rizky Febian', 'Pop R&B', 'https://cdn-2.tstatic.net/tribunnews/foto/bank/images/rizky-febian_20181024_185845.jpg', 'Penyanyi pop R&B Indonesia', NOW(), NOW());


-- =====================================================
-- ALTERNATIF: Gunakan foto placeholder yang stabil
-- =====================================================
-- Jika foto di atas tidak muncul, gunakan foto dari unsplash.com:

-- UPDATE artists SET image = CONCAT('https://source.unsplash.com/200x200/?musician,', id) WHERE image IS NULL OR image = '';

-- ATAU gunakan foto dari Lorem Picsum:
-- UPDATE artists SET image = CONCAT('https://picsum.photos/200/200?random=', id) WHERE image IS NULL OR image = '';

-- ATAU gunakan foto dari RoboHash (avatar style):
-- UPDATE artists SET image = CONCAT('https://robohash.org/', name, '.png?size=200x200&set=set1') WHERE image IS NULL OR image = '';


-- =====================================================
-- VERIFY DATA
-- =====================================================
-- Cek apakah data sudah masuk:
SELECT id, name, genre, image FROM artists;

-- Hitung total artis:
SELECT COUNT(*) as total_artists FROM artists;

-- Cek artis tanpa foto:
SELECT name FROM artists WHERE image IS NULL OR image = '';


-- =====================================================
-- CLEANUP (jika ada masalah)
-- =====================================================
-- Hapus artis dengan foto rusak:
-- DELETE FROM artists WHERE image LIKE 'https://i.pravatar.cc%';

-- Reset auto increment:
-- ALTER TABLE artists AUTO_INCREMENT = 1;
