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
        Schema::create('penayangans', function (Blueprint $table) {
            $table->id('id_penayangan');
            $table->unsignedBigInteger('id_film')->constrained('films')->onDelete('cascade');
            $table->unsignedBigInteger('id_sesi')->constrained('sesis')->onDelete('cascade');
            $table->unsignedBigInteger('id_studio')->constrained('studios')->onDelete('cascade');
            $table->text('nomor_kursi_terpakai')->nullable();
            $table->double('harga_tiket');
            $table->string('status');
            $table->date('tanggal_tayang');
            $table->timestamps();

            $table->foreign('id_sesi')->references('id_sesi')->on('sesi_tayangs')->onDelete('cascade');
            $table->foreign('id_film')->references('id_film')->on('films')->onDelete('cascade');
            $table->foreign('id_studio')->references('id_studio')->on('studios')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('penayangans');
    }
};
