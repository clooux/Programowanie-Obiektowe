<?php

namespace App\Controller;

use App\Entity\Project;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Doctrine\Persistence\ManagerRegistry;

#[Route("/api", name: "api_")]
class ProjectRestController extends AbstractController
{
    #[Route('/project', name: 'roject_index', methods: ['GET'])]
    public function index(ManagerRegistry $doctrine): Response
    {
        $projects = $doctrine
            ->getRepository(Project::class)
            ->findAll();
  
        $data = [];
  
        foreach ($projects as $project) {
           $data[] = [
               'id' => $project->getId(),
               'name' => $project->getName(),
               'description' => $project->getPrice(),
           ];
        }
  
  
        return $this->json($data);
    }

    #[Route('/project', name: 'project_new', methods: ['POST'])]
    public function new(ManagerRegistry $doctrine, Request $request): Response
    {
         $entityManager = $doctrine->getManager();
  
        $project = new Project();
        $project->setName($request->request->get('name'));
        $project->setDescription($request->request->get('description'));
  
        $entityManager->persist($project);
        $entityManager->flush();
  
        return $this->json('Created new project successfully with id ' . $project->getId());
    }

    #[Route('/project/{id}', name: 'project_show', methods: ['GET'])]
    public function show(ManagerRegistry $doctrine, int $id): Response
    {
        $project = $doctrine->getRepository(Project::class)->find($id);
  
        if (!$project) {
  
            return $this->json('No project found for id' . $id, 404);
        }
  
        $data =  [
            'id' => $project->getId(),
            'name' => $project->getName(),
            'price' => $project->getDescription(),
        ];
          
        return $this->json($data);
    }

    #[Route('/project/{id}', name: 'project_edit', methods: ["PUT"])]
    public function edit(ManagerRegistry $doctrine, Request $request, int $id): Response
    {
        $entityManager = $doctrine->getManager();
        $project= $entityManager->getRepository(Project::class)->find($id);
  
        if (!$project) {
            return $this->json('No product found for id' . $id, 404);
        }

        $parameters = json_decode($request->getContent(), true);
        
        $project->setName($parameters["name"]);
        $project->setDescription($parameters["price"]);
        $entityManager->flush();
  
        $data =  [
            'id' => $project->getId(),
            'name' => $project->getName(),
            'price' => $project->getDescription(),
        ];
          
        return $this->json($data);
    }

    #[Route('/project/{id}', name: 'project_delete', methods: ['DELETE'])]
    public function delete(ManagerRegistry $doctrine, int $id): Response
    {
        $entityManager = $doctrine->getManager();
        $project = $entityManager->getRepository(Project::class)->find($id);
  
        if (!$project) {
            return $this->json('No project found for id' . $id, 404);
        }
  
        $entityManager->remove($project);
        $entityManager->flush();
  
        return $this->json('Deleted a project successfully with id ' . $id);
    }
}
