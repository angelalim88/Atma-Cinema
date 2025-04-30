<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserController;
use App\Http\Controllers\FilmController;
use App\Http\Controllers\MenuController;
use App\Http\Controllers\BioskopController;
use App\Http\Controllers\PembayaranController;
use App\Http\Controllers\TransaksiController;
use App\Http\Controllers\StudioController;
use App\Http\Controllers\SesiTayangController;
use App\Http\Controllers\PenayanganController;
use App\Http\Controllers\TiketController;
use App\Http\Controllers\ReviewController;

// Auth routes
Route::post('/register', [UserController::class, 'register']);
Route::post('/login', [UserController::class, 'login']);

// User routes
Route::get('/users', [UserController::class, 'index']);
Route::get('/users/{id}', [UserController::class, 'show']);
Route::post('/users', [UserController::class, 'store']);
Route::post('/users/{id}', [UserController::class, 'update']);
Route::delete('/users/{id}', [UserController::class, 'destroy']);

// Film routes
Route::get('/films', [FilmController::class, 'index']);
Route::get('/films/{id}', [FilmController::class, 'show']);
Route::post('/films', [FilmController::class, 'store']);
Route::put('/films/{id}', [FilmController::class, 'update']);
Route::delete('/films/{id}', [FilmController::class, 'destroy']);

// Menu routes
Route::get('/menus', [MenuController::class, 'index']);
Route::get('/menus/{id}', [MenuController::class, 'show']);
Route::get('/menus/search/{id}', [MenuController::class, 'search']);
Route::post('/menus', [MenuController::class, 'store']);
Route::put('/menus/{id}', [MenuController::class, 'update']);
Route::delete('/menus/{id}', [MenuController::class, 'destroy']);

// Bioskop routes
Route::get('/bioskop', [BioskopController::class, 'index'   ]);
Route::get('/bioskop/{id}', [BioskopController::class, 'show']);
Route::post('/bioskop', [BioskopController::class, 'store']);
Route::put('/bioskop/{id}', [BioskopController::class, 'update']);
Route::delete('/bioskop/{id}', [BioskopController::class, 'destroy']);

// Studio routes
Route::get('/studio', [StudioController::class, 'index']);
Route::get('/studio/{id}', [StudioController::class, 'show']);
Route::post('/studio', [StudioController::class, 'store']);
Route::put('/studio/{id}', [StudioController::class, 'update']);
Route::delete('/studio/{id}', [StudioController::class, 'destroy']);
Route::post('/searchStudio', [StudioController::class, 'search']);

// Sesi routes
Route::get('/sesis', [SesiTayangController::class, 'index']);
Route::get('/sesis/{id}', [SesiTayangController::class, 'show']);
Route::post('/sesis', [SesiTayangController::class, 'store']);
Route::put('/sesis/{id}', [SesiTayangController::class, 'update']);
Route::delete('/sesis/{id}', [SesiTayangController::class, 'destroy']);

// Penayangan routes
Route::get('/penayangans', [PenayanganController::class, 'index']);
Route::get('/penayanganbyid/{id_film}', [PenayanganController::class, 'fetchById']);
Route::put('/penayangans/{id}', [PenayanganController::class, 'update']);
Route::delete('/penayangans/{id}', [PenayanganController::class, 'destroy']);
Route::post('/searchPenayangan', [PenayanganController::class, 'search']);

// Tiket routes
Route::get('/tikets/{id_user}', [TiketController::class, 'getByUser']);
Route::get('/tikets/{id}', [TiketController::class, 'show']);
Route::post('/tikets', [TiketController::class, 'store']);
Route::put('/tikets/{id}', [TiketController::class, 'update']);
Route::delete('/tikets/{id}', [TiketController::class, 'destroy']);

// Transaksi routes
Route::get('/transaksis', [TransaksiController::class, 'index']);
Route::get('/transaksis/{id}', [TransaksiController::class, 'show']);
Route::post('/transaksis', [TransaksiController::class, 'store']);
Route::put('/transaksis/{id}', [TransaksiController::class, 'update']);
Route::delete('/transaksis/{id}', [TransaksiController::class, 'destroy']);

// Review routes
Route::get('/reviews/{id_film}', [ReviewController::class, 'index']);
Route::get('/reviews/{id}', [ReviewController::class, 'show']);
Route::post('/reviews', [ReviewController::class, 'store']);
Route::put('/reviews/{id}', [ReviewController::class, 'update']);
Route::delete('/reviews/{id}', [ReviewController::class, 'destroy']);

// Pembayaran routes
Route::get('/pembayarans', [PembayaranController::class, 'index']);
Route::get('/pembayarans/{id}', [PembayaranController::class, 'show']);
Route::post('/pembayarans', [PembayaranController::class, 'store']);
Route::put('/pembayarans/{id}', [PembayaranController::class, 'update']);
Route::delete('/pembayarans/{id}', [PembayaranController::class, 'destroy']);