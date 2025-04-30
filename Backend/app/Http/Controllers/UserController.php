<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Log;
use Illuminate\Validation\Rule;

class UserController extends Controller
{
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'username' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:8',
            'nomor_telepon' => 'required|string|max:15',
            'profile_picture' => 'required',
            'tanggal_lahir' => 'required|date',
        ]);

        try {
            $profilePicture = 'default-profile.jpg';
            $user = User::create([
                'username' => $request->username,
                'email' => $request->email,
                'password' => Hash::make($request->password),
                'nomor_telepon' => $request->nomor_telepon,
                'tanggal_lahir' => $request->tanggal_lahir,
                'profile_picture' => $profilePicture,
            ]);
    
            // Check if a profile picture was uploaded
            if ($request->hasFile('profile_picture')) {
                $userId = $user->id_user; // Now $user->id will be available after the user is saved
                $filename = $userId . '_ProfPic.' . $request->file('profile_picture')->getClientOriginalExtension();
    
                // Store the uploaded profile picture
                $request->file('profile_picture')->storeAs('profile_pictures', $filename, 'public');
    
                // Update the user profile picture in the database
                $user->update(['profile_picture' => $filename]);
            }

            $token = $user->createToken('auth_token')->plainTextToken;

            return response()->json([
                'message' => 'User registered successfully',
                'user' => $user,
                'token' => $token
            ], 200);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Failed to register user: ' . $e->getMessage()], 500);
        }
    }

    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|string|email',
            'password' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }

        $user = User::where('email', $request->email)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json(['message' => 'Invalid email or password'], 401);
        }

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json(['message' => 'Login successful', 'token' => $token, 'user' => $user], 200);
    }

    public function index()
    {
        return response()->json(User::all(), 200);
    }

    public function store(Request $request)
    {
        $user = User::create($request->all());
        return response()->json($user, 201);
    }

    public function show($id)
    {
        $user = User::find($id);
        if (!$user) {
            return response()->json(['message' => 'User not found'], 404);
        }
        return response()->json($user, 200);
    }

    public function update(Request $request)
    {
        
        try{
            $user = User::find((int)$request->id);

            if (!$user) {
                return response()->json(['message' => 'User not found'], 404);
            }

            $emailRules = ['nullable', 'string', 'email', 'max:255'];

            if ($request->email && $request->email !== $user->email) {
                $emailRules[] = Rule::unique('users')->ignore($user->id_user, 'id_user'); // Ignore current user's email
            }


            $validator = Validator::make($request->all(), [
                'username' => 'nullable|string|max:255',
                'password' => 'nullable|string|min:8',
                'email' => $emailRules,
                'nomor_telepon' => 'nullable|string|max:15',
                'profile_picture' => 'nullable',
            ]);

            if ($validator->fails()) {
                return response()->json(['errors' => $validator->errors()], 422);
            }
            
            $profilePicturePath = $user->profile_picture; 
            if ($request->hasFile('profile_picture')) {
                $userId = $user->id_user;
                $filename = $userId . '_ProfPic.' . $request->file('profile_picture')->getClientOriginalExtension();
                $request->file('profile_picture')->storeAs('profile_pictures', $filename, 'public');
            }



            if($request->password == null) {
                $user->update([
                    'username' => $request->username,
                    'email' => $request->email,
                    'nomor_telepon' => $request->nomor_telepon,
                    'profile_picture' => $filename,
                ]);
            } else {

                if (!Hash::check($request->old_password, $user->password)) {
                    return response()->json([
                        'message' => 'Password lama salah',
                    ], 401);
                }

                $user->update([
                    'password' => Hash::make($request->password),
                ]);
            }

            return response()->json([
                'message' => 'Profile updated successfully',
                'user' => $user
            ], 200);

        }catch (\Exception $e){
            Log::error('User update failed: ' . $e->getMessage());
            return response()->json(['message' => 'Failed to update user profile'], 500);
        }
    }

    public function destroy($id)
    {
        $user = User::find($id);
        if (!$user) {
            return response()->json(['message' => 'User not found'], 404);
        }
        $user->delete();
        return response()->json(['message' => 'User deleted'], 200);
    }
}

