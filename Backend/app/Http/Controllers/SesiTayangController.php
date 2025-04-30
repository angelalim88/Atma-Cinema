<?php

namespace App\Http\Controllers;

use App\Models\SesiTayang; // Pastikan model yang digunakan adalah SesiTayang
use Illuminate\Http\Request;

class SesiTayangController extends Controller
{
    // Mendapatkan semua sesi
    public function index()
    {
        $sesis = SesiTayang::all(); // Gunakan SesiTayang
        return response()->json($sesis, 200);
    }

    // Menyimpan sesi baru
    public function store(Request $request)
    {
        $request->validate([
            'jam_mulai' => 'required|date_format:H:i:s',
            'jam_selesai' => 'required|date_format:H:i:s|after:jam_mulai',
        ]);

        $sesi = SesiTayang::create($request->all()); // Gunakan SesiTayang
        return response()->json($sesi, 201);
    }

    // Mendapatkan sesi berdasarkan ID
    public function show($id)
    {
        $sesis = SesiTayang::find($id); // Gunakan SesiTayang
        if (!$sesis) {
            return response()->json(['message' => 'Sesi not found'], 404);
        }
        return response()->json($sesis, 200);
    }

    // Mengupdate sesi
    public function update(Request $request, $id)
    {
        $sesis = SesiTayang::find($id); // Gunakan SesiTayang
        if (!$sesis) {
            return response()->json(['message' => 'Sesi not found'], 404);
        }
        $sesis->update($request->all());
        return response()->json($sesis, 200);
    }

    // Menghapus sesi
    public function destroy($id)
    {
        $sesis = SesiTayang::find($id); // Gunakan SesiTayang
        if (!$sesis) {
            return response()->json(['message' => 'Sesi not found'], 404);
        }
        $sesis->delete();
        return response()->json(['message' => 'Sesi deleted successfully'], 200);
    }
}