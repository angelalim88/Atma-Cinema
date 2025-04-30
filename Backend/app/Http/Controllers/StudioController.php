<?php

namespace App\Http\Controllers;

use App\Models\Studio;
use App\Models\Penayangan;
use Illuminate\Http\Request;

class StudioController extends Controller
{
    // Mendapatkan semua studio
    public function index()
    {
        $studios = Studio::all();
        return response()->json($studios, 200);
    }

    // Menyimpan studio baru
    public function store(Request $request)
    {
        $studio = Studio::create($request->all());
        return response()->json($studio, 201);
    }

    // Mendapatkan studio berdasarkan ID
    public function show($id)
    {
        $studio = Studio::find($id);
        if (!$studio) {
            return response()->json(['message' => 'Studio not found'], 404);
        }
        return response()->json($studio, 200);
    }

    // Mengupdate studio
    public function update(Request $request, $id)
    {
        $studio = Studio::find($id);
        if (!$studio) {
            return response()->json(['message' => 'Studio not found'], 404);
        }
        $studio->update($request->all());
        return response()->json($studio, 200);
    }

    // Menghapus studio
    public function destroy($id)
    {
        $studio = Studio::find($id);
        if (!$studio) {
            return response()->json(['message' => 'Studio not found'], 404);
        }
        $studio->delete();
        return response()->json(['message' => 'Studio deleted successfully'], 200);
    }

    public function search(Request $request) {
        // Validate the input
        // $validated = $request->validate([
        //     'id_film' => 'required',
        //     'id_bioskop' => 'required',
        // ]);

        $id_film = $request->id_film;
        $id_bioskop = $request->id_bioskop;

        // echo '<pre>';
        // print_r($id_film);
        // echo '</pre>';
        // dump($id_film);
        // $id_film->info();


        // Fetch studios based on id_film and id_bioskop
        $studios = Penayangan::where('id_film', $id_film)->get();
        $id_studios = $studios->pluck('id_studio')->toArray();
        $id_studios = array_unique($id_studios);

        $room = Studio::where('id_bioskop', $id_bioskop);
        $id_room = $room->pluck('id_studio')->toArray();
        $id_room = array_unique($id_room);

        $same_ids = array_intersect($id_studios, $id_room);
        $values = array_values($same_ids);
        $value = $values[0];

        $data = Studio::find($value);

        // Return the studio data
        return response()->json($data, 200);
    }
}
