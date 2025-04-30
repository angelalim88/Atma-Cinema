<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Tiket extends Model
{
    use HasFactory;

    protected $table = 'tikets';
    protected $primaryKey = 'id_tiket';
    protected $fillable = [
        'id_user',
        'id_penayangan',
        'nomor_kursi',
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'id_user');
    }

    public function penayangan()
    {
        return $this->belongsTo(Penayangan::class, 'id_penayangan');
    }

    public function transaksi()
    {
        return $this->hasOne(Transaksi::class, 'id_tiket');
    }

    public function review()
    {
        return $this->hasOne(Review::class, 'id_tiket');
    }
}