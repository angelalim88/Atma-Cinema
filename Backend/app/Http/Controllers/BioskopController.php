<?php

namespace App\Http\Controllers;

use App\Models\Bioskop;
use Illuminate\Http\Request;

class BioskopController extends Controller
{
    // Menampilkan semua bioskop
    public function index()
    {
        $bioskops = Bioskop::with('studios')->get();
        return response()->json($bioskops, 200);
    }

    // Menampilkan bioskop berdasarkan ID
    public function show($id)
    {
        $bioskop = Bioskop::with('studios')->find($id);

        if (!$bioskop) {
            return response()->json(['message' => 'Bioskop not found'], 404);
        }

        return response()->json($bioskop, 200);
    }

    // Menambahkan bioskop baru
    public function store(Request $request)
    {
        $validatedData = $request->validate([
            'nama_bioskop' => 'required|string|max:255',
            'alamat' => 'required|string|max:255',
        ]);

        $bioskop = Bioskop::create($validatedData);
        return response()->json($bioskop, 201);
    }

    // Mengupdate bioskop berdasarkan ID
    public function update(Request $request, $id)
    {
        $bioskop = Bioskop::find($id);

        if (!$bioskop) {
            return response()->json(['message' => 'Bioskop not found'], 404);
        }

        $validatedData = $request->validate([
            'nama_bioskop' => 'string|max:255',
            'alamat' => 'string|max:255',
        ]);

        $bioskop->update($validatedData);
        return response()->json($bioskop, 200);
    }

    // Menghapus bioskop berdasarkan ID
    public function destroy($id)
    {
        $bioskop = Bioskop::find($id);

        if (!$bioskop) {
            return response()->json(['message' => 'Bioskop not found'], 404);
        }

        $bioskop->delete();
        return response()->json(['message' => 'Bioskop deleted successfully'], 200);
    }
}