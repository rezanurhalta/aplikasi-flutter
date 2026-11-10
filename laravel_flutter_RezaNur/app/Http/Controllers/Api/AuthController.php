<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
// use App\Models\User;


class AuthController extends Controller
{
    public function login(Request $request){
        $request->validate(['email'=>'required|email',
        'password'=>'required'
        ]);
        if(!Auth::attempt($request->only('email','password'))){
            return response()->json([
                'success'=>false,
                'massage'=>'email/password salah'
            ],404);
        }
/** @var \App\Models\User $user */

//DIATAS ITU PERUBAHANNYA DARI GEMINI 

        $user=Auth::user();
        $token=$user->createToken('flutter')->plainTextToken;
        return response()->json(['success'=>true,
        'massage'=>'Login Berhasil',
        'token'=>$token,
        'user'=>$user
        
        ]);
    }
    public function logout(Request $request){
        $request->user()->currentAccessToken()->delete();
        return response()->json([
                'success'=>false,
                'massage'=>'email/password salah'
            ],404);
    }
}
