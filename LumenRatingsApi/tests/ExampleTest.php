<?php

class ExampleTest extends TestCase
{
    /**
     * A basic test example.
     *
     * @return void
     */
    public function test_it_gets_ratings()
    {
        $this->get('/ratings');
        $this->assertResponseStatus(200);
    }
}
