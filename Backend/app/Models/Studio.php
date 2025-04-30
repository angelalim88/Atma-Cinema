<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Studio extends Model
{
    use HasFactory;

    protected $table = 'studios';
    protected $primaryKey = 'id_studio';

    protected $fillable = [
        'id_bioskop',
        'nama_studio',
        'kapasitas',
        'nomor_kursi_tersedia',
    ];

    public function bioskop()
    {
        return $this->belongsTo(Bioskop::class, 'id_bioskop');
    }
}
