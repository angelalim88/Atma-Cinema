<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Bioskop extends Model
{
    use HasFactory;

    protected $table = 'bioskops';
    protected $primaryKey = 'id_bioskop';

    protected $fillable = [
        'nama_bioskop',
        'alamat',
    ];

    public function studios()
    {
        return $this->hasMany(Studio::class, 'id_bioskop');
    }
}
