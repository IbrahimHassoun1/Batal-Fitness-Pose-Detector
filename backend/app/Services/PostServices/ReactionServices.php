<?php

namespace App\Services\PostServices;

use App\Traits\IpApi;
use App\Models\Reaction;
use App\Models\Post;

class ReactionServices
{
    use IpApi;

    public function addReaction($request)
    {
        $userId = auth()->user()->id;
        //check if it had already existed
        $reaction = Reaction::withTrashed()
                ->where('user_id', $userId)
                ->where('post_id', $request['post_id'])
                ->first();
        if($reaction){
            
            if($reaction->trashed()){
                 Post::where('id',$request['post_id'])->increment('reactions');
                 
            }
           $reaction->restore();

            return $reaction;
        }

        

        $location = $this->getLocation($request->ip());

        $reaction=Reaction::create([
            'user_id' => $userId,
            'post_id' => $request['post_id']??null,
            'type'=> $request['type']??null,
            'country'=> $location['country']??null,
            'province'=> $location['region']??null,
            'city'=> $location['city']??null,
        ]);
        if(!$reaction){
            throw new \Exception("couldn't add reaction",400);
        }
        Post::where('id',$request['post_id'])->increment('reactions');

        return $reaction;
    }

    public function deleteReaction($request)
    {
        $userId = auth()->user()->id;

        $reaction = Reaction::where('user_id', $userId)
                    ->where('post_id', $request['post_id'])
                    ->first();

        if (!$reaction) {
            throw new \Exception("Reaction not found", 404);
        }

        $reaction->delete();
        Post::where('id',$request['post_id'])->decrement('reactions');
        return $reaction;
    }

    public function updateReaction($request)
    {
        $userId = auth()->user()->id;
        $reaction = Reaction::where("user_id", $userId)->where("post_id", $request['post_id'])->first();
        
        $reaction->type = $request['type'];

        if(!$reaction->save()){
            throw new \Exception("couldn't save update");
        }
        return $reaction;
    }
}