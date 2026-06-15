<?php

namespace Database\Seeders;

use App\Models\Bioskop;
use App\Models\Film;
use App\Models\Menu;
use App\Models\Pembayaran;
use App\Models\Penayangan;
use App\Models\Review;
use App\Models\SesiTayang;
use App\Models\Studio;
use App\Models\Tiket;
use App\Models\Transaksi;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        DB::statement('PRAGMA foreign_keys = OFF');

        Pembayaran::query()->delete();
        Review::query()->delete();
        Transaksi::query()->delete();
        Tiket::query()->delete();
        Penayangan::query()->delete();
        Studio::query()->delete();
        Bioskop::query()->delete();
        SesiTayang::query()->delete();
        Film::query()->delete();
        Menu::query()->delete();
        User::query()->delete();

        DB::statement('PRAGMA foreign_keys = ON');

        $users = collect([
            [
                'username' => 'richard.demo',
                'email' => 'richard@cineplex.local',
                'password' => Hash::make('Cineplex123'),
                'nomor_telepon' => '081234567890',
                'profile_picture' => '',
                'tanggal_lahir' => '2001-04-21',
            ],
            [
                'username' => 'nabila.moviegoer',
                'email' => 'nabila@cineplex.local',
                'password' => Hash::make('Cineplex123'),
                'nomor_telepon' => '082211223344',
                'profile_picture' => '',
                'tanggal_lahir' => '1999-09-14',
            ],
            [
                'username' => 'adit.reviewer',
                'email' => 'adit@cineplex.local',
                'password' => Hash::make('Cineplex123'),
                'nomor_telepon' => '085612340987',
                'profile_picture' => '',
                'tanggal_lahir' => '1998-12-03',
            ],
        ])->map(fn (array $data) => User::create($data));

        $bioskops = collect([
            [
                'nama_bioskop' => 'Cineplex Plaza Indonesia',
                'alamat' => 'Jl. M.H. Thamrin No.28-30, Jakarta Pusat',
            ],
            [
                'nama_bioskop' => 'Cineplex Pakuwon Mall',
                'alamat' => 'Jl. Puncak Indah Lontar No.2, Surabaya',
            ],
            [
                'nama_bioskop' => 'Cineplex Paris Van Java',
                'alamat' => 'Jl. Sukajadi No.137-139, Bandung',
            ],
        ])->map(fn (array $data) => Bioskop::create($data));

        $seatMap = collect(range('A', 'J'))
            ->flatMap(fn (string $row) => collect(range(1, 10))->map(fn (int $number) => $row . $number))
            ->implode(',');

        $studios = collect([
            ['id_bioskop' => $bioskops[0]->id_bioskop, 'nama_studio' => 'Studio Premier 1', 'kapasitas' => 100, 'nomor_kursi_tersedia' => $seatMap],
            ['id_bioskop' => $bioskops[0]->id_bioskop, 'nama_studio' => 'Studio Reguler 2', 'kapasitas' => 100, 'nomor_kursi_tersedia' => $seatMap],
            ['id_bioskop' => $bioskops[1]->id_bioskop, 'nama_studio' => 'Studio IMAX', 'kapasitas' => 100, 'nomor_kursi_tersedia' => $seatMap],
            ['id_bioskop' => $bioskops[2]->id_bioskop, 'nama_studio' => 'Studio Velvet', 'kapasitas' => 100, 'nomor_kursi_tersedia' => $seatMap],
        ])->map(fn (array $data) => Studio::create($data));

        $sesis = collect([
            ['jam_mulai' => '10:00:00', 'jam_selesai' => '12:15:00'],
            ['jam_mulai' => '13:15:00', 'jam_selesai' => '15:30:00'],
            ['jam_mulai' => '16:30:00', 'jam_selesai' => '18:45:00'],
            ['jam_mulai' => '19:30:00', 'jam_selesai' => '21:50:00'],
        ])->map(fn (array $data) => SesiTayang::create($data));

        $films = collect([
            [
                'judul' => 'Thunderbolts*',
                'genre' => 'Action, Superhero',
                'tahun_rilis' => 2025,
                'sutradara' => 'Jake Schreier',
                'aktor' => 'Florence Pugh, Sebastian Stan, David Harbour',
                'deskripsi' => 'Sekelompok antihero Marvel dipaksa bekerja sama dalam misi berbahaya yang membuka luka masa lalu mereka.',
                'poster_1' => 'thunderbolts_2025.jpg',
                'poster_2' => 'thunderbolts_2025.jpg',
                'trailer' => 'https://www.youtube.com/results?search_query=Thunderbolts+official+trailer',
                'rating' => 4.3,
                'status' => 'Now Playing',
            ],
            [
                'judul' => 'F1',
                'genre' => 'Sports, Drama',
                'tahun_rilis' => 2025,
                'sutradara' => 'Joseph Kosinski',
                'aktor' => 'Brad Pitt, Damson Idris, Javier Bardem',
                'deskripsi' => 'Seorang pembalap veteran kembali ke dunia Formula One untuk menyelamatkan tim sahabat lamanya yang sedang terpuruk.',
                'poster_1' => 'f1_2025.png',
                'poster_2' => 'f1_2025.png',
                'trailer' => 'https://www.youtube.com/results?search_query=F1+2025+official+trailer',
                'rating' => 4.7,
                'status' => 'Now Playing',
            ],
            [
                'judul' => 'How to Train Your Dragon',
                'genre' => 'Fantasy, Adventure',
                'tahun_rilis' => 2025,
                'sutradara' => 'Dean DeBlois',
                'aktor' => 'Mason Thames, Nico Parker, Gerard Butler',
                'deskripsi' => 'Hiccup membangun ikatan tak terduga dengan Toothless dan mengubah cara desanya memandang para naga.',
                'poster_1' => 'how_to_train_your_dragon_2025.jpg',
                'poster_2' => 'how_to_train_your_dragon_2025.jpg',
                'trailer' => 'https://www.youtube.com/results?search_query=How+to+Train+Your+Dragon+2025+official+trailer',
                'rating' => 4.8,
                'status' => 'Now Playing',
            ],
            [
                'judul' => 'Elio',
                'genre' => 'Animation, Adventure',
                'tahun_rilis' => 2025,
                'sutradara' => 'Madeline Sharafian, Domee Shi, Adrian Molina',
                'aktor' => 'Yonas Kibreab, Zoe Saldana, Remy Edgerly',
                'deskripsi' => 'Seorang anak yang merasa sendirian justru dianggap pemimpin Bumi ketika bertemu komunitas antargalaksi.',
                'poster_1' => 'elio_2025.jpg',
                'poster_2' => 'elio_2025.jpg',
                'trailer' => 'https://www.youtube.com/results?search_query=Elio+official+trailer',
                'rating' => 4.1,
                'status' => 'Now Playing',
            ],
            [
                'judul' => 'Lilo & Stitch',
                'genre' => 'Family, Sci-Fi Comedy',
                'tahun_rilis' => 2025,
                'sutradara' => 'Dean Fleischer Camp',
                'aktor' => 'Maia Kealoha, Sydney Agudong, Chris Sanders',
                'deskripsi' => 'Persahabatan Lilo dan eksperimen alien Stitch kembali hadir dalam versi live-action yang hangat dan kacau.',
                'poster_1' => 'lilo_and_stitch_2025.jpg',
                'poster_2' => 'lilo_and_stitch_2025.jpg',
                'trailer' => 'https://www.youtube.com/results?search_query=Lilo+and+Stitch+2025+official+trailer',
                'rating' => 4.4,
                'status' => 'Now Playing',
            ],
            [
                'judul' => 'Ballerina',
                'genre' => 'Action, Thriller',
                'tahun_rilis' => 2025,
                'sutradara' => 'Len Wiseman',
                'aktor' => 'Ana de Armas, Keanu Reeves, Ian McShane',
                'deskripsi' => 'Seorang pembunuh terlatih memburu orang-orang yang bertanggung jawab atas tragedi keluarganya di dunia John Wick.',
                'poster_1' => 'ballerina_2025.jpg',
                'poster_2' => 'ballerina_2025.jpg',
                'trailer' => 'https://www.youtube.com/results?search_query=Ballerina+2025+official+trailer',
                'rating' => 4.2,
                'status' => 'Now Playing',
            ],
            [
                'judul' => 'Mission: Impossible – The Final Reckoning',
                'genre' => 'Action, Spy',
                'tahun_rilis' => 2025,
                'sutradara' => 'Christopher McQuarrie',
                'aktor' => 'Tom Cruise, Hayley Atwell, Simon Pegg',
                'deskripsi' => 'Ethan Hunt menghadapi misi paling berisiko saat ancaman global baru menuntut keputusan mustahil.',
                'poster_1' => 'mission_impossible_final_reckoning_2025.jpg',
                'poster_2' => 'mission_impossible_final_reckoning_2025.jpg',
                'trailer' => 'https://www.youtube.com/results?search_query=Mission+Impossible+The+Final+Reckoning+official+trailer',
                'rating' => 4.7,
                'status' => 'Now Playing',
            ],
            [
                'judul' => 'Jurassic World Rebirth',
                'genre' => 'Sci-Fi, Adventure',
                'tahun_rilis' => 2025,
                'sutradara' => 'Gareth Edwards',
                'aktor' => 'Scarlett Johansson, Mahershala Ali, Jonathan Bailey',
                'deskripsi' => 'Misi ilmiah ke wilayah berbahaya berujung pada pertemuan baru dengan dinosaurus paling mematikan.',
                'poster_1' => 'jurassic_world_rebirth_2025.jpg',
                'poster_2' => 'jurassic_world_rebirth_2025.jpg',
                'trailer' => 'https://www.youtube.com/results?search_query=Jurassic+World+Rebirth+official+trailer',
                'rating' => 4.5,
                'status' => 'Now Playing',
            ],
            [
                'judul' => 'Superman',
                'genre' => 'Superhero, Adventure',
                'tahun_rilis' => 2025,
                'sutradara' => 'James Gunn',
                'aktor' => 'David Corenswet, Rachel Brosnahan, Nicholas Hoult',
                'deskripsi' => 'Clark Kent berusaha menyeimbangkan warisan Krypton dan kemanusiaannya dalam babak baru DC Studios.',
                'poster_1' => 'superman_2025.jpg',
                'poster_2' => 'superman_2025.jpg',
                'trailer' => 'https://www.youtube.com/results?search_query=Superman+2025+official+trailer',
                'rating' => 4.6,
                'status' => 'Now Playing',
            ],
            [
                'judul' => 'M3GAN 2.0',
                'genre' => 'Horror, Sci-Fi',
                'tahun_rilis' => 2025,
                'sutradara' => 'Gerard Johnstone',
                'aktor' => 'Allison Williams, Violet McGraw, Amie Donald',
                'deskripsi' => 'Boneka AI ikonis kembali dengan ancaman yang lebih besar, lebih pintar, dan jauh lebih sulit dikendalikan.',
                'poster_1' => 'm3gan_2_0_2025.jpg',
                'poster_2' => 'm3gan_2_0_2025.jpg',
                'trailer' => 'https://www.youtube.com/results?search_query=M3GAN+2.0+official+trailer',
                'rating' => 4.0,
                'status' => 'Now Playing',
            ],
            [
                'judul' => '28 Years Later',
                'genre' => 'Horror, Thriller',
                'tahun_rilis' => 2025,
                'sutradara' => 'Danny Boyle',
                'aktor' => 'Jodie Comer, Aaron Taylor-Johnson, Ralph Fiennes',
                'deskripsi' => 'Puluhan tahun setelah wabah rage, dunia yang rapuh kembali diteror oleh ancaman yang berkembang.',
                'poster_1' => '28_years_later_2025.jpg',
                'poster_2' => '28_years_later_2025.jpg',
                'trailer' => 'https://www.youtube.com/results?search_query=28+Years+Later+official+trailer',
                'rating' => 4.4,
                'status' => 'Now Playing',
            ],
            [
                'judul' => 'Final Destination Bloodlines',
                'genre' => 'Horror, Supernatural',
                'tahun_rilis' => 2025,
                'sutradara' => 'Zach Lipovsky, Adam Stein',
                'aktor' => 'Kaitlyn Santa Juana, Teo Briones, Richard Harmon',
                'deskripsi' => 'Warisan maut kembali menghantui satu keluarga yang mencoba memutus pola kematian yang tak terelakkan.',
                'poster_1' => 'final_destination_bloodlines_2025.jpg',
                'poster_2' => 'final_destination_bloodlines_2025.jpg',
                'trailer' => 'https://www.youtube.com/results?search_query=Final+Destination+Bloodlines+official+trailer',
                'rating' => 4.1,
                'status' => 'Now Playing',
            ],
            [
                'judul' => 'Avatar: Fire and Ash',
                'genre' => 'Sci-Fi, Epic Fantasy',
                'tahun_rilis' => 2025,
                'sutradara' => 'James Cameron',
                'aktor' => 'Sam Worthington, Zoe Saldana, Sigourney Weaver',
                'deskripsi' => 'Kisah Pandora berlanjut ketika konflik baru memperlihatkan sisi yang lebih kelam dari dunia Na’vi.',
                'poster_1' => 'avatar_fire_and_ash_2025.jpeg',
                'poster_2' => 'avatar_fire_and_ash_2025.jpeg',
                'trailer' => 'https://www.youtube.com/results?search_query=Avatar+Fire+and+Ash+official+trailer',
                'rating' => 4.9,
                'status' => 'Coming Soon',
            ],
            [
                'judul' => 'Zootopia 2',
                'genre' => 'Animation, Comedy',
                'tahun_rilis' => 2025,
                'sutradara' => 'Jared Bush, Byron Howard',
                'aktor' => 'Ginnifer Goodwin, Jason Bateman, Ke Huy Quan',
                'deskripsi' => 'Judy Hopps dan Nick Wilde kembali menghadapi kasus baru yang mengguncang kota hewan paling sibuk di dunia.',
                'poster_1' => 'zootopia_2_2025.jpg',
                'poster_2' => 'zootopia_2_2025.jpg',
                'trailer' => 'https://www.youtube.com/watch?v=5AwtptT8X8k',
                'rating' => 4.8,
                'status' => 'Coming Soon',
            ],
            [
                'judul' => 'Wicked: For Good',
                'genre' => 'Fantasy, Musical',
                'tahun_rilis' => 2025,
                'sutradara' => 'Jon M. Chu',
                'aktor' => 'Cynthia Erivo, Ariana Grande, Jonathan Bailey',
                'deskripsi' => 'Kelanjutan kisah Glinda dan Elphaba membawa konsekuensi besar bagi Oz dan persahabatan mereka.',
                'poster_1' => 'wicked_for_good_2025.jpg',
                'poster_2' => 'wicked_for_good_2025.jpg',
                'trailer' => 'https://www.youtube.com/watch?v=R2Xubj7lazE',
                'rating' => 4.7,
                'status' => 'Coming Soon',
            ],
            [
                'judul' => 'Tron: Ares',
                'genre' => 'Sci-Fi, Action',
                'tahun_rilis' => 2025,
                'sutradara' => 'Joachim Ronning',
                'aktor' => 'Jared Leto, Greta Lee, Evan Peters',
                'deskripsi' => 'Program canggih dari dunia digital menyeberang ke dunia nyata dan memicu ancaman teknologi baru.',
                'poster_1' => 'tron_ares_2025.jpg',
                'poster_2' => 'tron_ares_2025.jpg',
                'trailer' => 'https://www.youtube.com/watch?v=YShVEXb7-ic',
                'rating' => 4.5,
                'status' => 'Coming Soon',
            ],
            [
                'judul' => 'Predator: Badlands',
                'genre' => 'Action, Sci-Fi',
                'tahun_rilis' => 2025,
                'sutradara' => 'Dan Trachtenberg',
                'aktor' => 'Elle Fanning, Dimitrius Schuster-Koloamatangi',
                'deskripsi' => 'Semesta Predator bergerak ke lanskap baru yang liar dan mematikan dengan ancaman pemburu paling brutal.',
                'poster_1' => 'predator_badlands_2025.jpg',
                'poster_2' => 'predator_badlands_2025.jpg',
                'trailer' => 'https://www.youtube.com/watch?v=43R9l7EkJwE',
                'rating' => 4.4,
                'status' => 'Coming Soon',
            ],
            [
                'judul' => 'The Bad Guys 2',
                'genre' => 'Animation, Heist Comedy',
                'tahun_rilis' => 2025,
                'sutradara' => 'Pierre Perifel',
                'aktor' => 'Sam Rockwell, Marc Maron, Awkwafina',
                'deskripsi' => 'Geng penjahat favorit kembali terseret ke aksi pencurian baru yang lebih besar dan lebih absurd.',
                'poster_1' => 'the_bad_guys_2_2025.jpg',
                'poster_2' => 'the_bad_guys_2_2025.jpg',
                'trailer' => 'https://www.youtube.com/watch?v=TY1lWh20VSw',
                'rating' => 4.6,
                'status' => 'Coming Soon',
            ],
            [
                'judul' => 'The SpongeBob Movie: Search for SquarePants',
                'genre' => 'Animation, Family Comedy',
                'tahun_rilis' => 2025,
                'sutradara' => 'Derek Drymon',
                'aktor' => 'Tom Kenny, Bill Fagerbakke, Clancy Brown',
                'deskripsi' => 'SpongeBob memulai petualangan baru yang kacau saat ia terlibat pencarian besar di Bikini Bottom dan sekitarnya.',
                'poster_1' => 'spongebob_search_for_squarepants_2025.jpg',
                'poster_2' => 'spongebob_search_for_squarepants_2025.jpg',
                'trailer' => 'https://www.youtube.com/watch?v=XdPt8QWTypI',
                'rating' => 4.2,
                'status' => 'Coming Soon',
            ],
            [
                'judul' => 'Toy Story 5',
                'genre' => 'Animation, Family Adventure',
                'tahun_rilis' => 2026,
                'sutradara' => 'Andrew Stanton',
                'aktor' => 'Tom Hanks, Tim Allen, Joan Cusack',
                'deskripsi' => 'Woody, Buzz, dan para mainan kembali dalam petualangan baru yang menyorot tantangan generasi digital.',
                'poster_1' => 'toy_story_5_2026.jpg',
                'poster_2' => 'toy_story_5_2026.jpg',
                'trailer' => 'https://www.youtube.com/watch?v=c51ND9Hdbw0',
                'rating' => 4.8,
                'status' => 'Coming Soon',
            ],
            [
                'judul' => 'Hoppers',
                'genre' => 'Animation, Sci-Fi Comedy',
                'tahun_rilis' => 2026,
                'sutradara' => 'Daniel Chong',
                'aktor' => 'Piper Curda, Jon Hamm, Bobby Moynihan',
                'deskripsi' => 'Teknologi yang memindahkan kesadaran manusia ke tubuh robot hewan memicu petualangan liar dan lucu.',
                'poster_1' => 'hoppers_2026.jpg',
                'poster_2' => 'hoppers_2026.jpg',
                'trailer' => 'https://www.youtube.com/watch?v=PypDSyIRRSs',
                'rating' => 4.3,
                'status' => 'Coming Soon',
            ],
            [
                'judul' => 'The Cat in the Hat',
                'genre' => 'Animation, Family Fantasy',
                'tahun_rilis' => 2026,
                'sutradara' => 'Alessandro Carloni, Erica Rivinoja',
                'aktor' => 'Bill Hader, Quinta Brunson, Bowen Yang',
                'deskripsi' => 'Karakter klasik Dr. Seuss hadir kembali dalam petualangan animasi yang lebih modern, aneh, dan ekspresif.',
                'poster_1' => 'cat_in_the_hat_2026.png',
                'poster_2' => 'cat_in_the_hat_2026.png',
                'trailer' => 'https://www.youtube.com/watch?v=jz8pLlPhSeY',
                'rating' => 4.1,
                'status' => 'Coming Soon',
            ],
            [
                'judul' => 'Supergirl',
                'genre' => 'Superhero, Sci-Fi',
                'tahun_rilis' => 2026,
                'sutradara' => 'Craig Gillespie',
                'aktor' => 'Milly Alcock, Matthias Schoenaerts, Eve Ridley',
                'deskripsi' => 'Kara Zor-El mendapat sorotan utama dalam kisah DC baru yang menjanjikan nuansa lebih kosmis dan emosional.',
                'poster_1' => 'supergirl_2026.jpg',
                'poster_2' => 'supergirl_2026.jpg',
                'trailer' => 'https://www.youtube.com/watch?v=s1-pfiVMKAs',
                'rating' => 4.5,
                'status' => 'Coming Soon',
            ],
            [
                'judul' => 'The Mandalorian and Grogu',
                'genre' => 'Sci-Fi, Adventure',
                'tahun_rilis' => 2026,
                'sutradara' => 'Jon Favreau',
                'aktor' => 'Pedro Pascal, Sigourney Weaver, Jeremy Allen White',
                'deskripsi' => 'Din Djarin dan Grogu berlanjut ke layar lebar dalam misi Star Wars baru dengan skala yang lebih besar.',
                'poster_1' => 'the_mandalorian_and_grogu_2026.jpg',
                'poster_2' => 'the_mandalorian_and_grogu_2026.jpg',
                'trailer' => 'https://www.youtube.com/watch?v=IHWlvwu8t1w',
                'rating' => 4.7,
                'status' => 'Coming Soon',
            ],
        ])->map(fn (array $data) => Film::create($data));

        $today = Carbon::create(2026, 8, 1);

        $nowPlayingFilms = $films
            ->filter(fn (Film $film) => $film->status === 'Now Playing')
            ->values();

        $screeningTemplates = $nowPlayingFilms
            ->flatMap(function (Film $film, int $index) use ($sesis, $studios, $today) {
                $studioCount = $studios->count();
                $sesiCount = $sesis->count();
                $basePrice = 45000 + (($index % 4) * 5000);

                return [
                    [
                        'id_film' => $film->id_film,
                        'id_sesi' => $sesis[$index % $sesiCount]->id_sesi,
                        'id_studio' => $studios[$index % $studioCount]->id_studio,
                        'nomor_kursi_terpakai' => '12,13,14,25,26',
                        'harga_tiket' => $basePrice,
                        'status' => 'Available',
                        'tanggal_tayang' => $today->copy()->addDays(1 + ($index % 3))->toDateString(),
                    ],
                    [
                        'id_film' => $film->id_film,
                        'id_sesi' => $sesis[($index + 1) % $sesiCount]->id_sesi,
                        'id_studio' => $studios[($index + 1) % $studioCount]->id_studio,
                        'nomor_kursi_terpakai' => '1,2,3,41,42,51,52',
                        'harga_tiket' => $basePrice + 5000,
                        'status' => 'Available',
                        'tanggal_tayang' => $today->copy()->addDays(3 + ($index % 4))->toDateString(),
                    ],
                    [
                        'id_film' => $film->id_film,
                        'id_sesi' => $sesis[($index + 2) % $sesiCount]->id_sesi,
                        'id_studio' => $studios[($index + 2) % $studioCount]->id_studio,
                        'nomor_kursi_terpakai' => '',
                        'harga_tiket' => $basePrice + 10000,
                        'status' => 'Available',
                        'tanggal_tayang' => $today->copy()->addDays(6 + ($index % 5))->toDateString(),
                    ],
                ];
            })
            ->values();

        $legacyScreening = collect([
            [
                'id_film' => $nowPlayingFilms[0]->id_film,
                'id_sesi' => $sesis[0]->id_sesi,
                'id_studio' => $studios[3]->id_studio,
                'nomor_kursi_terpakai' => '15,16,17,18,19,20',
                'harga_tiket' => 60000,
                'status' => 'Not Available',
                'tanggal_tayang' => $today->copy()->subDays(2)->toDateString(),
            ],
        ]);

        $penayangans = $screeningTemplates
            ->concat($legacyScreening)
            ->map(fn (array $data) => Penayangan::create($data))
            ->values();

        $tikets = collect([
            [
                'id_user' => $users[0]->id_user,
                'id_penayangan' => $penayangans[0]->id_penayangan,
                'nomor_kursi' => 'B7,B8',
            ],
            [
                'id_user' => $users[0]->id_user,
                'id_penayangan' => $penayangans->last()->id_penayangan,
                'nomor_kursi' => 'C5',
            ],
            [
                'id_user' => $users[1]->id_user,
                'id_penayangan' => $penayangans[5]->id_penayangan,
                'nomor_kursi' => 'D4,D5',
            ],
            [
                'id_user' => $users[2]->id_user,
                'id_penayangan' => $penayangans[10]->id_penayangan,
                'nomor_kursi' => 'A1,A2',
            ],
        ])->map(fn (array $data) => Tiket::create($data));

        $transaksis = collect([
            [
                'id_tiket' => $tikets[0]->id_tiket,
                'metode_pembayaran' => 'Gopay',
                'nominal_pembayaran' => 100000,
            ],
            [
                'id_tiket' => $tikets[1]->id_tiket,
                'metode_pembayaran' => 'Dana',
                'nominal_pembayaran' => 60000,
            ],
            [
                'id_tiket' => $tikets[2]->id_tiket,
                'metode_pembayaran' => 'Shopee Pay',
                'nominal_pembayaran' => 110000,
            ],
        ])->map(fn (array $data) => Transaksi::create($data));

        collect([
            [
                'id_transaksi' => $transaksis[0]->id_transaksi,
                'nama_metode' => 'Gopay',
                'jenis' => 'E-Wallet',
                'gambar' => '',
            ],
            [
                'id_transaksi' => $transaksis[1]->id_transaksi,
                'nama_metode' => 'Dana',
                'jenis' => 'E-Wallet',
                'gambar' => '',
            ],
            [
                'id_transaksi' => $transaksis[2]->id_transaksi,
                'nama_metode' => 'Shopee Pay',
                'jenis' => 'E-Wallet',
                'gambar' => '',
            ],
        ])->each(fn (array $data) => Pembayaran::create($data));

        collect([
            [
                'id_tiket' => $tikets[1]->id_tiket,
                'rating' => 4.5,
                'komentar' => 'Visualnya hangat dan emosional. Cocok banget buat ditonton bareng keluarga.',
            ],
        ])->each(fn (array $data) => Review::create($data));

        collect([
            [
                'nama' => 'Caramel Popcorn',
                'jenis' => 'Snack',
                'harga' => 45000,
                'deskripsi' => 'Popcorn karamel ukuran large dengan rasa manis gurih khas bioskop.',
                'gambar' => 'caramel_popcorn.jpg',
            ],
            [
                'nama' => 'Cheese Nachos',
                'jenis' => 'Snack',
                'harga' => 38000,
                'deskripsi' => 'Nachos renyah dengan saus keju hangat, cocok untuk sharing.',
                'gambar' => 'cheese_nachos.jpg',
            ],
            [
                'nama' => 'Coca-Cola Classic',
                'jenis' => 'Drink',
                'harga' => 25000,
                'deskripsi' => 'Minuman cola dingin klasik yang pas untuk pasangan snack bioskop favoritmu.',
                'gambar' => 'coca_cola.jpg',
            ],
            [
                'nama' => 'Fresh Iced Tea',
                'jenis' => 'Drink',
                'harga' => 22000,
                'deskripsi' => 'Es teh segar dengan rasa ringan untuk menemani sesi nonton yang panjang.',
                'gambar' => 'iced_tea.jpg',
            ],
            [
                'nama' => 'Classic Hot Dog',
                'jenis' => 'Snack',
                'harga' => 34000,
                'deskripsi' => 'Roti hot dog lembut dengan sosis gurih dan topping mustard klasik.',
                'gambar' => 'hot_dog.png',
            ],
            [
                'nama' => 'Crispy French Fries',
                'jenis' => 'Snack',
                'harga' => 30000,
                'deskripsi' => 'Kentang goreng renyah dengan porsi pas untuk teman nonton santai.',
                'gambar' => 'french_fries.jpg',
            ],
        ])->each(fn (array $data) => Menu::create($data));
    }
}
