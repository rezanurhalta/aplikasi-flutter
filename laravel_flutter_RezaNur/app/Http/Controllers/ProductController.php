<?php

namespace App\Http\Controllers;

use App\Models\Product;
use Illuminate\Http\Request;


class ProductController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return Response()->json(Product::latest()->get(), 200);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create() {}

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'nama' => 'required',
            'harga' => 'required',
            'stok' => 'required',
            'deskripsi' => 'required',
            'gambar' => 'nullable|image'

        ]);
        $gambar = "";
        if ($request->hasFile("gambar")) {
            $gambar = time() . "." .
                $request->gambar->extension();
            $request->gambar->storeAs(
                "product",
                $gambar,
                "public"
            );
        }
        $product = Product::create([
            'nama' => $request->nama,
            'harga' => $request->harga,
            'stok' => $request->stok,
            'deskripsi' => $request->deskripsi,
            'gambar' => $gambar
        ]);
        return response()->json([
            'message' => 'Data berhasil ditambahkan',
            'data' => $product
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(String $id)
    {
        $product = Product::find($id);
        if (!$product) {
            return response()->json([
                'message' => 'data tidak ditemukan'
            ], 404);
        }
        return response()->json($product);
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Product $product)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $product = Product::find($id);
        if (!$product) {
            return response()->json([
                'message' => 'data tidak ditemukan'
            ], 404);
        }
        $product->nama =$request->nama;
        $product->harga =$request->harga;
        $product->stok =$request->stok;
        $product->deskripsi =$request->deskripsi;

        if ($request->hasFile("gambar")) {
            $gambar = time() . "." .
                $request->gambar->extension();
            $request->gambar->storeAs(
                "product",
                $gambar,
                "public"
            );
            $product->gambar = $gambar;
        }
        // $product->update([
        //     'nama' => $request->nama,
        //     'harga' => $request->harga,
        //     'stok' => $request->stok,
        //     'deskripsi' => $request->deskripsi,

        // ]);
          $product->save();
        return response()->json([
            'message' => 'Data berhasil diubah',
            'data' => $product
        ],);
        
      
    }
    /**
     * Remove the specified resource from storage.
     */
    public function destroy(String $id)
    {
        $product = Product::find($id);
        if (!$product) {
            return response()->json([
                'message' => 'data tidak ditemukan'
            ], 404);
        }
        $product->delete();
        return response()->json([
            'message' => 'data berhasil dihapus'
        ], 201);
    }
}
