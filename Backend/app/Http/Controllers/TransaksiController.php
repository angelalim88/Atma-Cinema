<?php

namespace App\Http\Controllers;

use App\Models\Transaksi;
use App\Models\Tiket;
use Illuminate\Http\Request;

class TransaksiController extends Controller
{
    // Menampilkan semua transaksi
    public function index()
    {
        $transaksis = Transaksi::with('tiket')->get(); // Mengambil semua transaksi beserta tiketnya
        return response()->json($transaksis, 200);
    }

    // Menampilkan transaksi berdasarkan ID
    public function show($id)
    {
        $transaksi = Transaksi::with('tiket')->find($id);

        if (!$transaksi) {
            return response()->json(['message' => 'Transaksi not found'], 404);
        }

        return response()->json($transaksi, 200);
    }

    // Menambahkan transaksi baru
    public function store(Request $request)
    {
        $validatedData = $request->validate([
            'id_tiket' => 'required|exists:tikets,id_tiket', // Tiket harus ada di tabel tiket
            'metode_pembayaran' => 'required|string|max:255',
            'nominal_pembayaran' => 'required|numeric|min:0',
        ]);

        $transaksi = Transaksi::create($validatedData);
        return response()->json($transaksi, 200);
    }

    // Mengupdate transaksi berdasarkan ID
    public function update(Request $request, $id)
    {
        $transaksi = Transaksi::find($id);

        if (!$transaksi) {
            return response()->json(['message' => 'Transaksi not found'], 404);
        }

        $validatedData = $request->validate([
            'id_tiket' => 'exists:tikets,id_tiket',
            'metode_pembayaran' => 'string|max:255',
            'nominal_pembayaran' => 'numeric|min:0',
        ]);

        $transaksi->update($validatedData);
        return response()->json($transaksi, 200);
    }

    // Menghapus transaksi berdasarkan ID
    public function destroy($id)
    {
        $transaksi = Transaksi::find($id);

        if (!$transaksi) {
            return response()->json(['message' => 'Transaksi not found'], 404);
        }

        $transaksi->delete();
        return response()->json(['message' => 'Transaksi deleted successfully'], 200);
    }
}