package ru.gmtmsk.addressbook.config;

import java.util.ArrayList;
import java.util.List;

public class TreeNode {
    private String name;
    private boolean isFolder;
    private List<TreeNode> children = new ArrayList<>();

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public boolean isFolder() {
        return isFolder;
    }

    public void setFolder(boolean folder) {
        isFolder = folder;
    }

    public List<TreeNode> getChildren() {
        return children;
    }

    public void setChildren(List<TreeNode> children) {
        this.children = children;
    }

    public TreeNode buildTree(List<String> paths) {
        TreeNode root = new TreeNode();
        root.setName("Локальные нормативные акты ГАУ ИНПЦ Гормедтехника");
        root.setFolder(true);

        for (String path : paths) {
            String[] parts = path.split("/");
            TreeNode current = root;

            for (int i = 0; i < parts.length; i++) {
                String part = parts[i];
                TreeNode child = findChild(current, part);

                if (child == null) {
                    child = new TreeNode();
                    child.setName(part);
                    child.setFolder(i < parts.length - 1); // Последний элемент — файл
                    current.getChildren().add(child);
                }

                current = child;
            }
        }

        return root;
    }

    private TreeNode findChild(TreeNode node, String name) {
        for (TreeNode child : node.getChildren()) {
            if (child.getName().equals(name)) {
                return child;
            }
        }
        return null;
    }
}
