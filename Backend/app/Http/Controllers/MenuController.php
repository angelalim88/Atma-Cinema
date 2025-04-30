<?php

namespace App\Http\Controllers;

use App\Models\Menu;
use Illuminate\Http\Request;

class MenuController extends Controller
{
    public function index()
    {
        $menus = Menu::all();
        $menus->map(function ($menu) {
            // Mengubah path gambar menjadi URL yang bisa diakses
            $menu->gambar = 'http://10.0.2.2:8000/storage/menu/' . $menu->gambar;
            
            // Mengonversi harga ke double
            $menu->harga = (double) $menu->harga;

            return $menu;
        });

        return response()->json($menus, 200);
    }


    public function store(Request $request)
    {
        $request->validate([
            'nama' => 'required|string|max:255',
            'jenis' => 'required|string|max:255',
            'harga' => 'required|numeric|min:0',
            'deskripsi' => 'nullable|string',
            'gambar' => 'nullable|file|image',
        ]);

        try {
            // Membuat data menu baru
            $menu = Menu::create([
                'nama' => $request->nama,
                'jenis' => $request->jenis,
                'harga' => (double) $request->harga,
                'deskripsi' => $request->deskripsi,
                'gambar' => '', // Menyimpan gambar sebagai string kosong terlebih dahulu
            ]);

            // Mengecek apakah ada gambar yang diupload
            if ($request->hasFile('gambar')) {
                $gambarMenu = $request->file('gambar');
                $filename = $menu->id . '_Menu.' . $gambarMenu->getClientOriginalExtension();
                $extension = $gambarMenu->getClientOriginalExtension();
                // Menyimpan gambar di folder storage/menu
                $gambarMenu->storeAs('menu', $filename, 'public');
                
                // Mengupdate gambar yang disimpan di database
                $menu->update(['gambar' => $filename]);
            }

            return response()->json($menu, 201);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Failed to create menu: ' . $e->getMessage()], 500);
        }
    }


    public function search($id)
    {
        $menu = Menu::find($id);

        if (!$menu) {
            return response()->json(['message' => 'Menu not found'], 404);
        }

        $menu->gambar = 'http://10.0.2.2:8000/storage/menu/' . $menu->gambar;
        $menu->harga = (double) $menu->harga;

        return response()->json($menu, 200);
    }

    public function show(Menu $menu)
    {
        $menu->gambar = 'http://10.0.2.2:8000/storage/menu/' . $menu->gambar;
        $menu->harga = (double) $menu->harga;

        return response()->json($menu, 200);
    }

    public function update(Request $request, Menu $menu)
    {
        $request->validate([
            'nama' => 'nullable|string|max:255',
            'jenis' => 'nullable|string|max:255',
            'harga' => 'nullable|numeric|min:0',
            'deskripsi' => 'nullable|string',
            'gambar' => 'nullable|image|mimes:jpeg,png,jpg|max:2048',
        ]);

        try {
            $menu->update([
                'nama' => $request->nama ?? $menu->nama,
                'jenis' => $request->jenis ?? $menu->jenis,
                'harga' => $request->has('harga') ? (double) $request->harga : $menu->harga,
                'deskripsi' => $request->deskripsi ?? $menu->deskripsi,
            ]);

            if ($request->hasFile('gambar')) {
                $gambarMenu = $request->file('gambar');
                $filename = $menu->id_menu . '_Menu.' . $gambarMenu->getClientOriginalExtension();
                $gambarMenu->move(public_path('gambar'), $filename);

                $menu->update(['gambar' => $filename]);
            }

            return response()->json($menu, 200);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Failed to update menu: ' . $e->getMessage()], 500);
        }
    }

    public function destroy(Menu $menu)
    {
        $menu->delete();
        return response()->json(['message' => 'Menu deleted successfully'], 200);
    }
}
