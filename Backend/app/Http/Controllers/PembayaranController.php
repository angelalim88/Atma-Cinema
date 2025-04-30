<?php

namespace App\Http\Controllers;

use App\Models\Pembayaran;
use App\Models\Transaksi;
use Illuminate\Http\Request;

class PembayaranController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        // Mengambil semua pembayaran beserta data transaksi terkait
        $pembayaran = Pembayaran::with('transaksi')->get();
        return response()->json($pembayaran);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'id_transaksi' => 'required|exists:transaksis,id_transaksi',
            'nama_metode' => 'required|string',
            'jenis' => 'required|string',
            'gambar' => 'required',
        ]);

        try{
            $tempPaymentPicture = 'default-profile.jpg';
            $pembayaran = Pembayaran::create([
                'id_transaksi' => $request->id_transaksi,
                'nama_metode' => $request->nama_metode,
                'jenis' => $request->jenis,
                'gambar' => $tempPaymentPicture,
            ]);

            if ($request->hasFile('gambar')) {
                $gambar = $request->file('gambar');
                $filename = $pembayaran->id_pembayaran . '_Pembayaran.' . $gambar->getClientOriginalExtension();
                $gambar->move(public_path('pembayaran'), $filename);

                $pembayaran->update([
                    'gambar' => $filename
                ]);
            }
            return response()->json($pembayaran, 201);
        }catch(\Exception $e){
            return response()->json(['error' => 'Failed to add pembayaran: ' . $e->getMessage()], 500);
        }
    }

    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        // Mengambil pembayaran berdasarkan ID dan termasuk data transaksi
        $pembayaran = Pembayaran::with('transaksi')->findOrFail($id);
        return response()->json($pembayaran);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        $pembayaran = Pembayaran::findOrFail($id);

        // Validasi input
        $validated = $request->validate([
            'id_transaksi' => 'nullable|required|exists:transaksis,id',
            'nama_metode' => 'nullable|required|string',
            'jenis' => 'nullable|required|string',
            'gambar' => 'nullable|required|string',
        ]);

        // Memperbarui data pembayaran
        $pembayaran->update($validated);

        return response()->json($pembayaran);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        $pembayaran = Pembayaran::findOrFail($id);
        $pembayaran->delete();

        return response()->json(['message' => 'Pembayaran deleted successfully.']);
    }
}
