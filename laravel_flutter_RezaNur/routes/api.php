<?php

use App\Http\Controllers\Api\AuthController;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ProductController;

Route::get('/test',function(){
    return response()->json(['message'=>'API berhasil tersambung']);});
    Route::post('/login',[AuthController::class,'login']);

    Route::middleware('auth:sanctum')->group(function(){
        Route::post('logout',[AuthController::class,'login']);
    Route::apiResource('products',ProductController::class);
});