<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SesiTayang extends Model
{
    protected $table = 'sesi_tayangs'; 
    protected $primaryKey = 'id_sesi';
    public $incrementing = true; 
    protected $keyType = 'int'; // Tipe data primary key

    protected $fillable = [
        'jam_mulai',
        'jam_selesai',
    ];

    public function sesi()
    {
        return $this->belongsTo(SesiTayang::class, 'id_sesi', 'id_sesi');
    }
}