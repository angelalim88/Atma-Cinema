<?php

namespace App\Http\Controllers;

use App\Models\Review;
use Illuminate\Http\Request;

class ReviewController extends Controller
{
    // Mendapatkan semua review
    public function index($id_film)
    {
        // Ambil data review dengan relasi
        $reviews = Review::with([
            'tiket:id_tiket,id_user,id_penayangan',
            'tiket.user:id_user,username,profile_picture',
            'tiket.penayangan:id_penayangan,id_film,status',
        ])
        ->whereHas('tiket.penayangan.film', function($query) use ($id_film) {
            $query->where('id_film', $id_film);
        })
        ->get();
    
        // Modifikasi URL profile_picture untuk setiap review
        $reviews = $reviews->map(function ($review) {
            if ($review->tiket->user->profile_picture) {
                // Check if the URL is already complete
                if (!str_starts_with($review->tiket->user->profile_picture, 'http://10.0.2.2:8000/')) {
                    $review->tiket->user->profile_picture =
                        'http://10.0.2.2:8000/storage/profile_pictures/' . $review->tiket->user->profile_picture;
                }
            }
            return $review;
        });
    
        return response()->json($reviews, 200);
    }

    // Menyimpan review baru
    public function store(Request $request)
    {
        // Validasi input awal
        $validatedData = $request->validate([
            'id_tiket' => 'required|integer|exists:tikets,id_tiket', // Pastikan tiket valid
            'rating' => 'required|numeric|min:0|max:5', // Rating antara 0-5
            'komentar' => 'required|string|max:255', // Komentar maksimal 255 karakter
        ]);

        // Periksa apakah tiket memiliki status penayangan "Not Available"
        $tiket = \DB::table('tikets')
            ->join('penayangans', 'tikets.id_penayangan', '=', 'penayangans.id_penayangan')
            ->select('penayangans.status')
            ->where('tikets.id_tiket', $validatedData['id_tiket'])
            ->first();

        if (!$tiket || $tiket->status !== 'Not Available') {
            return response()->json(['message' => 'You cannot review this movie.'], 403);
        }

        // Simpan data review ke database
        $review = Review::create([
            'id_tiket' => $validatedData['id_tiket'],
            'rating' => $validatedData['rating'],
            'komentar' => $validatedData['komentar'],
        ]);

        // Kembalikan respon sukses
        return response()->json([
            'message' => 'Review created successfully',
            'data' => $review,
        ], 201);
    }

    // Mendapatkan review berdasarkan ID
    public function show($id)
    {
        $review = Review::find($id);
        if (!$review) {
            return response()->json(['message' => 'Review not found'], 404);
        }
        return response()->json($review, 200);
    }

    // Mengupdate review
    public function update(Request $request, $id)
    {
        $review = Review::find($id);
        if (!$review) {
            return response()->json(['message' => 'Review not found'], 404);
        }
        $review->update($request->all());
        return response()->json($review, 200);
    }

    // Menghapus review
    public function destroy($id)
    {
        $review = Review::find($id);
        if (!$review) {
            return response()->json(['message' => 'Review not found'], 404);
        }
        $review->delete();
        return response()->json(['message' => 'Review deleted successfully'], 200);
    }
}
