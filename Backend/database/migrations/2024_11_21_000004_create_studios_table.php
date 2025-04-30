<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('studios', function (Blueprint $table) {
            $table->id('id_studio');
            $table->unsignedBigInteger('id_bioskop'); // Pastikan tipe datanya cocok
            $table->string('nama_studio');
            $table->integer('kapasitas');
            $table->text('nomor_kursi_tersedia')->nullable();
            $table->timestamps();
        
            $table->foreign('id_bioskop')->references('id_bioskop')->on('bioskops')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('studios');
    }
};
