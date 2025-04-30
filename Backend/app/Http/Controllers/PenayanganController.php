<?php

namespace App\Http\Controllers;

use App\Models\Penayangan;
use Illuminate\Http\Request;

class PenayanganController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $penayangans = Penayangan::with(['film', 'studio', 'sesi'])->get();
        return response()->json($penayangans);
    }

    /**
     * Search for resources based on criteria.
     */
    public function search(Request $request)
    {
        // Validasi parameter input
        $validated = $request->validate([
            'id_studio' => 'required|integer',
            'id_film' => 'required|integer',
            'id_sesi' => 'required|integer',
            'tanggal_tayang' => 'required|date',
        ]);

        // Ambil parameter yang divalidasi
        $id_studio = $validated['id_studio'];
        $id_film = $validated['id_film'];
        $id_sesi = $validated['id_sesi'];
        $tanggal_tayang = $validated['tanggal_tayang'];
        
        // Cari data Penayangan berdasarkan parameter
        $penayangan = Penayangan::where('id_studio', $id_studio)
        ->where('id_film', $id_film)
        ->where('id_sesi', $id_sesi)
        ->whereDate('tanggal_tayang', $tanggal_tayang)
        ->get();
        
        // Periksa apakah data ditemukan
        if ($penayangan->isEmpty()) {
            return response()->json([
                'message' => 'No screenings found for the given parameters.',
                'data' => []
            ], 404);
        }

        // Kembalikan data Penayangan
        return response()->json($penayangan[0], 200);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'id_film' => 'required|exists:films,id_film',
            'id_sesi' => 'required|exists:sesi_tayangs,id_sesi',
            'id_studio' => 'required|exists:studios,id_studio',
            'nomor_kursi_terpakai' => 'required|integer|min:0',
            'harga_tiket' => 'required|numeric|min:0',
            'status' => 'required|string',
            'tanggal_tayang' => 'required|date',
        ]);

        $penayangan = Penayangan::create($request->all());
        return response()->json($penayangan);
    }

    /**
     * Display the specified resource.
     */
    public function show(Penayangan $penayangan)
    {
        return response()->json($penayangan->load(['film', 'studio', 'sesi']));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        $penayangan = Penayangan::find($id);

        $request->validate([
            'id_film' => 'nullable|exists:films,id',
            'id_sesi' => 'nullable|exists:sesi_tayangs,id',
            'id_studio' => 'nullable|exists:studios,id',
            'nomor_kursi_terpakai' => 'nullable',
            'harga_tiket' => 'nullable|numeric|min:0',
            'status' => 'nullable|string',
            'tanggal_tayang' => 'nullable|date',
        ]);

        $penayangan->update($request->all());
        return response()->json($penayangan);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Penayangan $penayangan)
    {
        $penayangan->delete();
        return response()->json(['message' => 'Penayangan deleted successfully']);
    }

    public function fetchById($id_film)
{
    $penayangan = Penayangan::with([
        'film:id_film,judul,genre,tahun_rilis,poster_1',
        'studio:id_studio,id_bioskop,nama_studio,nomor_kursi_tersedia',
        'studio.bioskop:id_bioskop,nama_bioskop',
        'sesi:id_sesi,jam_mulai,jam_selesai'
    ])
    ->select('id_penayangan', 'id_film', 'id_sesi', 'id_studio', 'nomor_kursi_terpakai', 'harga_tiket', 'status', 'tanggal_tayang') // Explicitly select columns excluding created_at and updated_at
    ->whereHas('film', function($query) use ($id_film) {
        $query->where('id_film', $id_film);
    })
    ->get();

    return response()->json($penayangan, 200);
}
}
