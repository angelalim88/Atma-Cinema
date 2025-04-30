<?php

namespace App\Http\Controllers;

use App\Models\Film;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class FilmController extends Controller
{
    // Mendapatkan semua film
    public function index()
    {
        $films = Film::all();
        $films->map(function ($film) {
            // Menambahkan URL untuk poster_1
            $film->poster_1 = 'http://10.0.2.2:8000/storage/poster_1/' . $film->poster_1;
            
            // Menambahkan URL untuk poster_2
            $film->poster_2 = 'http://10.0.2.2:8000/storage/poster_2/' . $film->poster_2;
    
            return $film;
        });
        return response()->json(['films' => $films], 200);
    }

    // Menyimpan film baru
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'judul' => 'required|string|max:255|unique:films,judul',
            'genre' => 'required|string|max:255',
            'deskripsi' => 'required',
            'tahun_rilis' => 'required|integer|min:1900|max:' . date('Y'),
            'durasi' => 'required|integer|min:1',
            'sutradara' => 'required|string|max:255',
            'aktor' => 'required|string|max:255',
            'trailer' => 'nullable|string',
            'rating' => 'nullable|numeric|min:0|max:5',
            'status' => 'required|string',
            'poster_1' => 'nullable|file|image',
            'poster_2' => 'nullable|file|image',
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }

        try {
            $film = Film::create([
                'judul' => $request->judul,
                'genre' => $request->genre,
                'deskripsi' => $request->deskripsi,
                'tahun_rilis' => $request->tahun_rilis,
                'durasi' => $request->durasi,
                'sutradara' => $request->sutradara,
                'aktor' => $request->aktor,
                'trailer' => $request->trailer,
                'rating' => $request->rating,
                'status' => $request->status,
            ]);

            if ($request->hasFile('poster_1')) {
                $poster1 = $request->file('poster_1');
                $poster1Name = $film->id_film . '_Poster_1.' . $poster1->getClientOriginalExtension();
                $poster1->move(public_path('poster_1'), $poster1Name);
            }
            
            if ($request->hasFile('poster_2')) {
                $poster2 = $request->file('poster_2');
                $poster2Name = $film->id_film . '_Poster_2.' . $poster2->getClientOriginalExtension();
                $poster2->move(public_path('poster_2'), $poster2Name);
            }
            
            $film->update([
                'poster_1' => $poster1Name,
                'poster_2' => $poster2Name,
            ]);

            return response()->json($film, 201);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Failed to save film: ' . $e->getMessage()], 500);
        }
    }

    // Mendapatkan film berdasarkan ID
    public function show($id)
    {
        $film = Film::find($id);
        if (!$film) {
            return response()->json(['message' => 'Film not found'], 404);
        }
        return response()->json($film, 200);
    }

    // Mengupdate film
    public function update(Request $request, $id)
    {
        $film = Film::find($id);
        if (!$film) {
            return response()->json(['message' => 'Film not found'], 404);
        }
        $film->update($request->all());
        return response()->json($film, 200);
    }

    // Menghapus film
    public function destroy($id)
    {
        $film = Film::find($id);
        if (!$film) {
            return response()->json(['message' => 'Film not found'], 404);
        }
        $film->delete();
        return response()->json(['message' => 'Film deleted successfully'], 200);
    }
}
