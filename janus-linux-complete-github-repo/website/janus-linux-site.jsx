import React from 'react';
import { Button } from '@/components/ui/button';
import { Card, CardContent } from '@/components/ui/card';

export default function JanusLinuxLanding() {
  return (
    <main className='min-h-screen bg-black text-white p-6'>
      <div className='max-w-5xl mx-auto text-center space-y-10'>
        <h1 className='text-5xl font-bold'>Janus Linux</h1>
        <p className='text-xl text-gray-400'>AI-powered Arch-based hacking distro</p>
        <Button className='bg-purple-600 hover:bg-purple-700'>Download ISO</Button>
      </div>
    </main>
  );
}
