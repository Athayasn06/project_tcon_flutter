<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class ArtistSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $artists = [
            // BAND INDONESIA TERKENAL
            [
                'name' => 'NOAH',
                'genre' => 'Pop Rock',
                'image' => 'https://yt3.googleusercontent.com/bVxQhgf0bHqYP2JWZ5QZ5QZ5QZ5QZ5QZ5QZ5QZ5QZ5QZ5QZ5QZ5QZ5QZ=s900-c-k-c0x00ffffff-no-rj',
                'bio' => 'Band pop rock Indonesia yang dibentuk pada tahun 2012, sebelumnya dikenal sebagai Peterpan.',
            ],
            [
                'name' => 'Sheila on 7',
                'genre' => 'Pop Rock',
                'image' => 'https://i1.sndcdn.com/avatars-000615947297-8iqxfq-t500x500.jpg',
                'bio' => 'Band pop rock legendaris Indonesia yang dibentuk sejak 1996.',
            ],
            [
                'name' => 'Dewa 19',
                'genre' => 'Rock',
                'image' => 'https://yt3.googleusercontent.com/ytc/AIdro_kQZ5QZ5QZ5QZ5QZ5QZ5QZ5QZ5QZ=s900-c-k-c0x00ffffff-no-rj',
                'bio' => 'Band rock Indonesia yang sangat legendaris dengan lagu-lagu ikonik.',
            ],
            [
                'name' => 'Slank',
                'genre' => 'Rock',
                'image' => 'https://yt3.googleusercontent.com/ytc/AIdro_kslank123456789=s900-c-k-c0x00ffffff-no-rj',
                'bio' => 'Band rock Indonesia yang sudah malang melintang sejak 1983.',
            ],
            
            // PENYANYI SOLO PRIA
            [
                'name' => 'Tulus',
                'genre' => 'Jazz Pop',
                'image' => 'https://i.scdn.co/image/ab6761610000e5eb0a5b3b3b3b3b3b3b3b3b3b3b',
                'bio' => 'Penyanyi solo dengan suara khas yang menyanyikan lagu-lagu jazz dan pop.',
            ],
            [
                'name' => 'Afgan',
                'genre' => 'R&B Pop',
                'image' => 'https://i1.sndcdn.com/avatars-afgan-t500x500.jpg',
                'bio' => 'Penyanyi pop dan R&B Indonesia dengan suara merdu.',
            ],
            [
                'name' => 'Judika',
                'genre' => 'Pop Ballad',
                'image' => 'https://i.scdn.co/image/ab6761610000e5ebjudika123',
                'bio' => 'Penyanyi pop ballad dengan vokal yang sangat powerful.',
            ],
            [
                'name' => 'Andmesh Kamaleng',
                'genre' => 'Pop',
                'image' => 'https://i1.sndcdn.com/avatars-andmesh-t500x500.jpg',
                'bio' => 'Penyanyi pop Indonesia yang terkenal dengan lagu "Cinta Luar Biasa".',
            ],
            [
                'name' => 'Rizky Febian',
                'genre' => 'Pop R&B',
                'image' => 'https://i.scdn.co/image/ab6761610000e5ebrizky123',
                'bio' => 'Penyanyi muda berbakat dengan genre pop R&B.',
            ],
            
            // PENYANYI SOLO WANITA
            [
                'name' => 'Raisa',
                'genre' => 'R&B Pop',
                'image' => 'https://i.scdn.co/image/ab6761610000e5ebraisa456',
                'bio' => 'Penyanyi R&B dan pop wanita Indonesia dengan suara khas.',
            ],
            [
                'name' => 'Isyana Sarasvati',
                'genre' => 'Classical Pop',
                'image' => 'https://i1.sndcdn.com/avatars-isyana-t500x500.jpg',
                'bio' => 'Penyanyi dan pianis Indonesia dengan background musik klasik.',
            ],
            [
                'name' => 'Rossa',
                'genre' => 'Pop',
                'image' => 'https://i.scdn.co/image/ab6761610000e5ebrossa789',
                'bio' => 'Diva pop Indonesia yang sudah berkarir sejak lama.',
            ],
            [
                'name' => 'Mahalini',
                'genre' => 'Pop',
                'image' => 'https://i1.sndcdn.com/avatars-mahalini-t500x500.jpg',
                'bio' => 'Penyanyi pop muda Indonesia dengan suara yang sangat indah.',
            ],
            [
                'name' => 'Lyodra',
                'genre' => 'Pop Soul',
                'image' => 'https://i.scdn.co/image/ab6761610000e5eblyodra123',
                'bio' => 'Juara Indonesian Idol 2020 dengan vokal yang luar biasa.',
            ],
            [
                'name' => 'Marion Jola',
                'genre' => 'Pop R&B',
                'image' => 'https://i1.sndcdn.com/avatars-marion-t500x500.jpg',
                'bio' => 'Penyanyi pop R&B Indonesia dengan karakter vokal yang unik.',
            ],
            [
                'name' => 'Tiara Andini',
                'genre' => 'Pop',
                'image' => 'https://i.scdn.co/image/ab6761610000e5ebtiara456',
                'bio' => 'Runner up Indonesian Idol 2020 yang sukses berkarir solo.',
            ],
            
            // BAND LAINNYA
            [
                'name' => 'Padi Reborn',
                'genre' => 'Pop Rock',
                'image' => 'https://yt3.googleusercontent.com/padi-reborn-avatar=s900-c-k-c0x00ffffff-no-rj',
                'bio' => 'Band pop rock Indonesia yang comeback dengan formasi baru.',
            ],
            [
                'name' => 'Ungu',
                'genre' => 'Pop Rock',
                'image' => 'https://i1.sndcdn.com/avatars-ungu-band-t500x500.jpg',
                'bio' => 'Band pop rock ballad Indonesia yang sangat terkenal.',
            ],
            [
                'name' => 'The Changcuters',
                'genre' => 'Indie Rock',
                'image' => 'https://yt3.googleusercontent.com/changcuters-avatar=s900-c-k-c0x00ffffff-no-rj',
                'bio' => 'Band indie rock dari Bandung dengan lagu-lagu ceria.',
            ],
            [
                'name' => 'D\'Masiv',
                'genre' => 'Pop Rock',
                'image' => 'https://i.scdn.co/image/ab6761610000e5ebdmasiv123',
                'bio' => 'Band pop rock Indonesia dengan banyak hits.',
            ],
        ];

        // Insert ke database
        foreach ($artists as $artist) {
            DB::table('artists')->insert([
                'name' => $artist['name'],
                'genre' => $artist['genre'],
                'image' => $artist['image'],
                'bio' => $artist['bio'] ?? null,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
        
        echo "✅ Berhasil insert " . count($artists) . " artis dengan foto!\n";
    }
}
