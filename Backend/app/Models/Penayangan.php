<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Penayangan extends Model
{
    use HasFactory;

    public $timestamps = false;
    protected $table = 'penayangans';
    protected $primaryKey = 'id_penayangan';
    protected $fillable = [
        'id_film',
        'id_sesi',
        'id_studio',
        'nomor_kursi_terpakai',
        'harga_tiket',
        'status',
        'tanggal_tayang',
    ];

    public function film()
    {
        return $this->belongsTo(Film::class, 'id_film');
    }

    public function sesi()
    {
        return $this->belongsTo(SesiTayang::class, 'id_sesi');
    }

    public function studio()
    {
        return $this->belongsTo(Studio::class, 'id_studio');
    }

    public function tikets()
    {
        return $this->hasMany(Tiket::class, 'id_penayangan');
    }
}