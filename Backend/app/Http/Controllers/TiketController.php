<?php

namespace App\Http\Controllers;

use App\Models\Tiket;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;

class TiketController extends Controller
{
    // Mendapatkan semua tiket
    public function getByUser($id_user)
    {

        $tikets = Tiket::with('penayangan:id_penayangan,tanggal_tayang,id_film,id_sesi,id_studio,harga_tiket,status', 'penayangan.film:id_film,judul,genre,poster_1', 'penayangan.sesi:id_sesi,jam_mulai', 
        'penayangan.studio:id_studio,nama_studio,id_bioskop', 'penayangan.studio.bioskop:id_bioskop,nama_bioskop')  
                ->where('id_user', $id_user)        
                ->get();


        $tikets->each(function($tiket) {
            if ($tiket->penayangan && $tiket->penayangan->film) {
                $posterUrl = $tiket->penayangan->film->poster_1;

                if (strpos($posterUrl, 'http://10.0.2.2:8000/storage/poster_1/') === false) {
                    $tiket->penayangan->film->poster_1 = 'http://10.0.2.2:8000/storage/poster_1/' . $posterUrl;
                }
            }
        });
        return response()->json($tikets, 200);
    }
    // Menyimpan tiket baru
    public function store(Request $request)
    {

        $validateData = $request->validate([
            'id_user' => 'required',
            'id_penayangan' => 'required',
            'nomor_kursi' => 'required',
        ]);

        $tiket = Tiket::create([
            'id_user' => $validateData['id_user'],
            'id_penayangan' => $validateData['id_penayangan'],
            'nomor_kursi' => $validateData['nomor_kursi'],
        ]);

        return response()->json($tiket, 200);
    }

    public function show($id)
    {
        $tiket = Tiket::find($id);
        if (!$tiket) {
            return response()->json(['message' => 'Tiket not found'], 404);
        }
        return response()->json($tiket, 200);
    }

    // Mengupdate tiket
    public function update(Request $request, $id)
    {
        $tiket = Tiket::find($id);
        if (!$tiket) {
            return response()->json(['message' => 'Tiket not found'], 404);
        }
        $tiket->update($request->all());
        return response()->json($tiket, 200);
    }

    // Menghapus tiket
    public function destroy($id)
    {
        $tiket = Tiket::find($id);
        if (!$tiket) {
            return response()->json(['message' => 'Tiket not found'], 404);
        }
        $tiket->delete();
        return response()->json(['message' => 'Tiket deleted successfully'], 200);
    }
}
